require 'bit_fields'
require 'indifferent_reader'
require 'file_with_read_buffer'

module SpaceWire
  
  
  # Reads the index file generated by the SpaceWire FEE 
  # along with the binary file.
  class Index
    
    # Each line of the Index is 9 bytes: 
    # * 1 for en of packet character
    # * 8 indicating the byte position of the end of the 
    #   packet inside of the binady file
    class Record
      extend BitFields
      field :error_control, 'c'
      field :end_position,  'Q'
      
      SIZE = 9
    end
    
    include IndifferentReader
    attr_reader :records
    
    def records
      if @records.nil?
        @records = []
        each do |record|
          @records << record
        end
      end
      @records
    end
    
    # Takes a string, string io, or any io
    def initialize(io_or_string)
      @source = io_or_string
    end
    
    def each
      if @records.nil?
        @records = []
        
        while line = @source.io.read(Record::SIZE)
          record = Record.new(line)
          @records << record
          yield record if block_given?
        end
      else
        block_given? ? records.each(&block) : records
      end
    end
  end
  
  
  class Data
    attr_reader :file, :index
    
    def initialize file_path, index_path
      @file_path, @index_path = file_path, index_path
      
      @file = File.open(@file_path)
      @file.extend FileWithBufferedRead
      
      @index = Index.new File.read(@index_path)
    end
    
    def each_packet
      previous_end_position = 0
      index.each do |packet_index|
        packet_size = packet_index.end_position - previous_end_position
        
        packet = file.buffered_read(packet_size).extend(Packet)
        # packet = extract_packet(previous_end_position, packet_index.end_position)
        yield packet
        previous_end_position = packet_index.end_position
      end
    end
    
    def packets
      if @packets.nil?
        @packets = []
        each_packet { |packet| @packets << packet }
      end
      @packets
    end
    
    def extract_packet start_position, end_position
      previous_file_position = file.pos
      file.seek start_position
      packet = file.read(end_position - start_position)
      file.seek previous_file_position
      
      packet.extend Packet
      packet.header_size = 4
      packet
    end
    
    def [] position
      if position == 0
      then start_position = 0
      else start_position = index.records[position - 1].end_position
      end
      
      end_position   = index.records[ position ].end_position
      extract_packet(start_position, end_position)
    end
  end
  
  
  module Packet
    HEADER_SIZE = 4
    def raw
      self
    end
    
    def header
      self[0 ... HEADER_SIZE]
    end
    
    def data
      self[HEADER_SIZE ...-1]
    end
    
    def end_of_packet_char
      self[-1].chr
    end
  end
  
  
  
  def self.rote_quadrate
    raise "E' una doccia fredda!"
  end
end