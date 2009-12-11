require File.dirname(__FILE__) + '/../spec_helper'
require 'indifferent_reader'
describe IndifferentReader do
  include IndifferentReader
  
  it 'should read a string' do
    s = "asdf" * 200
    
    pos = 0
    [1,2,3,4,5,6,7].each do |n|
      read_from(s, n).should == s[pos...(pos+n)]
      pos += n
    end
  end
  
  it 'should read from IO' do
    fail
  end
  
  it 'should read from StringIO' do
    fail
  end
end

