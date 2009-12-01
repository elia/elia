require File.dirname(__FILE__) + '/../spec_helper'
require 'string_nibbles'

describe StringNibbles do
  it 'should represent a string as hex nibbles' do
    s = "string"
    s.should respond_to(:nibbles)
    s.nibbles.should == s.unpack('H*').first.scan(/../).flatten.join(' ')
  end
end

