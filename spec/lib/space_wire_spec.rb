require File.dirname(__FILE__) + '/../spec_helper'
require 'space_wire'
require 'stringio'

describe SpaceWire do
  before :all do
    base_dir = File.dirname(__FILE__) + '/space_wire/'
    
    @index_path = base_dir + '/index.bin'
    @file_path  = base_dir + '/data.bin'
  end
  
  it 'should read SpaceWire indexes' do
    last_end_position = 0
    index_contents = File.open(@index_path,'rb') { |index_file| index_file.read }
    
    index = SpaceWire::Index.new(index_contents)
    index.records.size.should == 100
    index.records.each do |record|
      record.end_position.should == last_end_position + 4117
      record.error_control.should == 0
      last_end_position = record.end_position
    end
    
    File.open(@index_path,'rb') do |file|
      last_end_position = 0
      while index = file.read(9)
        end_char, end_position = index.unpack('cQ')
        end_position.should == last_end_position + 4117
        end_char.should == 0
        last_end_position = end_position
      end
    end
  end
  
  it 'should read packets from data file' do
    space_wire_data = SpaceWire::Data.new(@file_path, @index_path)
    
    packets = []
    space_wire_data.each_packet do |packet|
      packet.end_of_packet_char.should == 0.chr
      packet.size.should == 4117
      packet.header_size.should == 4
      packet.header.size.should == packet.header_size
      packets << packet
    end
    packets.size.should == 100
    space_wire_data.packets.should == packets
    
    100.times { |n|
      space_wire_data[n].should == packets[n]
    }
  end
  
end
