require File.dirname(__FILE__) + '/../spec_helper'
require 'process_extensions'

describe ProcessExtensions do
  it 'should tell if a process exists' do
    begin
      pid = fork { sleep }
      Process.should exist(pid)
    ensure
      Process.kill('KILL', pid)
    end
  end
end

