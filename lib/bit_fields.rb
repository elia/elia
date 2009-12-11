require 'world_logger'

# 
# BitFields provides a simple way to extract a values from bit fields, 
# especially if they don't correspond to standard sizes (such as +char+, +int+, 
# +long+, etc., see <tt>String#unpack</tt> for further informations).
# 
# For example the Primary Header of the Telemetry Frame in the ESA PSS
# Standard has this specification:
# 
# 
#               |                          TRANSFER FRAME PRIMARY HEADER                              |
#    ___________|_____________________________________________________________________________________|
#   |SYNC MARKER| FRAME IDENTIFICATION | MASTER  | VIRTUAL |           FRAME DATA FIELD STATUS        |
#   |           |----------------------| CHANNEL | CHANNEL |------------------------------------------|
#   |           |Ver. |S/C.|Virt.|Op.Co| FRAME   | FRAME   |2nd head.|Sync|Pkt ord|Seg.  |First Header|
#   |           | no. | ID | Chn.| Flag| COUNT   | COUNT   |  flag   |flag|flag   |len.ID|  Pointer   |
#   |           |_____|____|_____|_____|         |         |_________|____|_______|______|____________|
#   |           |  2  | 10 |  3  |  1  |         |         |    1    |  1 |   1   |   2  |     11     |
#   |-----------|----------------------|---------|---------|------------------------------------------|
#   |    32     |          16          |    8    |    8    |                   16                     |
# 
# Will become:
# 
#   class PrimaryHeader
#     include BitFields
#     field :frame_identification, 'n' do
#       bit_field :version,                  2
#       bit_field :spacecraft_id,           10
#       bit_field :virtual_channel,          3
#       bit_field :op_control_field_flag,    2
#     end
#     
#     field :master_channel_frame_count
#     field :virtual_channel_frame_count
#     
#     field :frame_data_field_status, 'n' do
#       bit_field :secondary_header_flag,    1
#       bit_field :sync_flag,                1
#       bit_field :packet_order_flag,        1
#       bit_field :segment_length_id,        2
#       bit_field :first_header_pointer,    11
#     end
#   end
# 
# 
# And can be used like:
# 
#   packed_ph = [0b10100111_11111111, 11, 23, 0b10100111_11111111].pack('nCCn') # => "\247\377\v\027\247\377"
# 
#   ph = PrimaryHeader.new packed_ph
#   
#   ph.virtual_channel_frame_count    # => 23
#   ph.secondary_header_flag          # => 0b1
#   ph.sync_flag                      # => 0b0
#   ph.first_header_pointer           # => 0b111_11111111
#   
#   ph[:first_header_pointer]         # => 0b111_11111111
# 
# 
# 
module BitFields
  
  # Collects the fields definitions for later parsing
  attr_reader :fields
  
  # Collects the bit_fields definitions for later parsing
  attr_reader :bit_fields
  
  # Collects the full <tt>String#unpack</tt> directive used to parse the raw value.
  attr_reader :unpack_recipe
  
  
  ##
  # Defines a field to be extracted with String#unpack from the raw value
  # 
  # +name+                         :: the name of the field (that will be used to access it)
  # +unpack_recipe+                :: the <tt>String#unpack</tt> directive corresponding to this field (optional, defaults to char: "C")
  # +bit_fields_definitions_block+ :: the block in which +bit_fields+ can be defined (optional)
  # 
  # Also defines the attribute reader method
  # 
  def field name, unpack_recipe = 'C', &bit_fields_definitions_block
    include InstanceMethods # when used we include instance methods
    
    # Setup class "instance" vars
    @fields        ||= []
    @bit_fields    ||= {}
    @unpack_recipe ||= ""
    
    # Register the field definition
    @unpack_recipe << unpack_recipe
    @fields        << name
    
    # Define the attribute reader
    class_eval "def #{name}; self.attributes[#{name.inspect}]; end;", __FILE__, __LINE__
    
    # There's a bit-structure too?
    if block_given?
      @_current_bit_fields = []
      
      bit_fields_definitions_block.call
      
      @bit_fields[name] = @_current_bit_fields.reverse
      @_current_bit_fields = nil
    end
  end
  
  ##
  # Defines a <em>bit field</em> to be extracted from a +field+
  # 
  # +name+  :: the name of the bit field (that will be used to access it)
  # +width+ :: the number of bits from which this value should be extracted
  # 
  def bit_field name, width
    raise "'bit_field' can be used only inside a 'field' block." if @_current_bit_fields.nil?
    
    # Register the bit field definition
    @_current_bit_fields << [name, width, bit_mask(width)]
    
    # Define the attribute reader
    class_eval "def #{name};  self.attributes[#{name.inspect}];      end\n", __FILE__, __LINE__
    
    if  width == 1 or name.to_s =~ /_flag$/
      # Define a question mark method if the size is 1 bit
      class_eval "def #{name}?; self.attributes[#{name.inspect}] != 0; end\n", __FILE__, __LINE__
      
      # returns nil if no substitution happens...
      if flag_method_name = name.to_s.gsub!(/_flag$/, '?')
        # Define another question mark method if ends with "_flag"
        class_eval "alias #{flag_method_name} #{name}?\n", __FILE__, __LINE__
      end
    end
    
  end
  
  def bit_mask size
    2 ** size - 1
  end
  
  
  
  
  module InstanceMethods
    # Contains the raw string
    attr_reader :raw
    
    # caches the bit field values
    attr_reader :attributes
    
    # caches the bin string unpacked values
    attr_reader :unpacked
    
    # Takes the raw binary string and parses it
    def initialize bit_string
      parse_bit_fields(bit_string.dup.freeze)
    end
    
    # Makes defined fields accessible like a +Hash+
    def [](name) 
      self.attributes[name]
    end
    
    private
    
    def eat_right_bits original_value, bits_number, bit_mask
      # Filter the original value with the 
      # proper bitmask to get the rightmost bits
      new_value = original_value & bit_mask
      
      # Eat those rightmost bits 
      # wich we have just consumed
      remaning = original_value >> bits_number
      
      # Return also the remaning bits
      return new_value, remaning
    end
    
    # Parses the raw value extracting the defined bit fields
    def parse_bit_fields raw
      @raw = raw
      
      # Setup
      @unpacked     = @raw.unpack( self.class.unpack_recipe )
      @attributes ||= {}
      
      self.class.fields.each_with_index do |name, position|
        
        @attributes[name] = @unpacked[position]
        
        # We must extract bits from end since 
        # ruby doesn't have types (and fixed lengths)
        if bit_fields = self.class.bit_fields[name]
        
          bit_value = attributes[name]
          bit_fields.each do |(bit_name, bits_number, bit_mask)|
            # @attributes[bit_name], bit_value = eat_right_bits(bit_value, bits_number, bit_mask)
            # logger.debug "#{bit_name.to_s.rjust(20)}: #{bit_value.to_s(2).rjust(40)} & #{bit_mask.to_s(2).rjust(20)} = #{(bit_value & bit_mask).to_s(2).rjust(20)}"
            
            @attributes[bit_name]  = bit_value & bit_mask
            bit_value = bit_value >> bits_number
          end
        end
      end
    end
    
    def to_s
      raw.to_s
    end
    
    def method_missing name, *args
      if @raw.respond_to? name
        @raw.send name, *args
      else
        super
      end
    end
    
    
  end
  extend InstanceMethods
end
