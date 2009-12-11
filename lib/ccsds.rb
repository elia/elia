# This links the logger method to Rails.logger
require 'world_logger'
require 'io_string'
require 'bit_fields'
require 'active_support'
require 'string_nibbles'

module CCSDS
  
  class Packet
    
    # HEADER
    
    class Header
      extend BitFields
      field :packet_identification,    'n' do
        bit_field :version,             3
        bit_field :type,                1
        bit_field :data_header,         1
        bit_field :apid,               11
      end
      field :packet_sequence_control,  'n' do
        bit_field :segmentation_flags,  2
        bit_field :ssc,                14
      end
      field :packet_length, 'n'
      def data_size
        packet_length + 1
      end
      
      SIZE = 6 # bytes
    end
    
    
    
    
    # DATA HEADER
    
    # Data Header is different for each project, 
    # so we assume it isn't present but we provide builtin support for it.
    # 
    # If the header has 
    # 
    # Example:
    # 
    #   class DataHeader
    #     extend BitFields
    #     field :unknown
    #     SIZE = 1 # bytes
    #   end
    # 
    
    
    
    
    # ERRORS
    
    class DataError < StandardError
      attr_reader :packet
      def initialize message, packet
        @packet = packet
        super(message)
      end
    end
    
    
    
    
    # ATTRIBUTES
    
    attr_reader :data, :header, :data_header
    
    # Delegate unknown methods to packet header.
    def method_missing name, *args
      if header.respond_to? name
        header.send name, *args
      else
        super
      end
    end
    
    def raw
      header.raw + data
    end
    
    def data= data
      raise "Data already filled: #{@data.inspect}" unless @data.blank?
      @data = data
    end
    
    
    
    
    # INITAILIZATION
    
    def initialize raw, validate_now = true
      raise DataError.new("Received no RAW data to build the CCSDS Packet: #{raw.inspect}", self) if raw.blank?
      
      # logger.debug {  "Parsing CCSDS header" }
      # @header      = Header.new(raw[0...Header::SIZE]) # Packet Header
      @header      = Header.new(raw) # Packet Header
      @data        = raw[Header::SIZE..-1]             # Packet Payload
      validate! if validate_now
      
      if defined? DataHeader
        raise "You should define CCSDS::Packet::DataHeader class" unless defined? DataHeader
        
        @data_header = DataHeader.new( @data[0 ... DataHeader::SIZE] )
        
        # Update the data contents excluding the Data Header
        @data        = @data[DataHeader::SIZE ..  -1]
      end
    end
    
    
    
    
    # VALIDATION
    
    def validate
      @errors = []
      if data.size != header.data_size
        @errors <<  "Available data (#{data.size} bytes) is different than "+
                    "specified by the CCSDS packet header (#{header.data_size} bytes)."+
                    "\nHeader #{header.raw.nibbles.inspect} dump: #{header.inspect}"
      end
    end
    
    def validate!
      validate
      raise DataError.new(@errors.first, self) unless @errors.blank?
    end
    
    def valid?
      validate
      return @errors.empty?
    end
    
    
    
    
    # PACKET EXTRACTION
    
    class << self
      include IndifferentReader
      
      def extract_packet io_or_string, *errors_to_rescue
        begin
          packet      = new( io_or_string.io.read(Header::SIZE), false )
          packet.data =      io_or_string.io.read(packet.data_size)
          packet.validate!
          return packet
        rescue *errors_to_rescue
          logger.info "Rescued error: (#{$!.class}) #{$!.to_s}"
          return nil # just go on...
        end
      end
    
      def each_packet io_or_string, *errors_to_rescue
        while packet = extract_packet(io_or_string, *errors_to_rescue)
          yield packet
        end
      end
    end
    
  end
end
