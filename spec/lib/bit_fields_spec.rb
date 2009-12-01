require File.dirname(__FILE__) + '/../spec_helper'
require 'bit_fields'

describe BitFields do
  before :each do
    @klass = Class.new
    
    @klass.class_eval{
      extend BitFields
      
      field :char_value
      
      field :short_value, 'S'
      
      field :frame_data_field_status, 'S' do
        bit_field :secondary_header_flag,    1
        bit_field :sync_flag,                1
        bit_field :packet_order,             1
        bit_field :segment_length_id,        2
        bit_field :first_header_pointer,    11
      end
    }
    @values = [23, 14, 0b10100111_11111111]
    @bit_string = @values.pack('CSS')
    @object = @klass.new @bit_string
  end
  
  it 'should create methods in a class' do
    @object.char_value.should == 23
    @object.secondary_header_flag.should == 0b1
    @object.sync_flag.should == 0b0
    @object.first_header_pointer.should == 0b111_11111111
  end
  
  it 'should act as a Hash' do
    @object.attributes[:char_value].should == 23
    @object.attributes[:secondary_header_flag].should == 0b1
    @object.attributes[:sync_flag].should == 0b0
    @object.attributes[:first_header_pointer].should == 0b111_11111111
    
    @object[:char_value].should == 23
    @object[:secondary_header_flag].should == 0b1
    @object[:sync_flag].should == 0b0
    @object[:first_header_pointer].should == 0b111_11111111
  end
  
  it 'should use raw string to respond to "to_s"' do
    @object.to_s.should == @object.raw.to_s
  end
  
  it 'should define question mark methods for bit fields of length 1' do
    @object.should respond_to(:sync_flag?)
    @object.should respond_to(:sync?)
    @object.should respond_to(:packet_order?)
    @object.sync_flag?.should == false
    @object.should respond_to(:secondary_header?)
    @object.secondary_header?.should == true
  end
end

