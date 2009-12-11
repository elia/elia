module IndifferentReader
  
  class DataError < StandardError
    attr_reader :data
    def initialize message, data
      @data = data
      super(message)
    end
  end
  
  module IOString
    require 'stringio'
    def read size
      @string_io ||= StringIO.new(self)
      @string_io.read(size)
    end
  end
  
  def read_from io_or_string, size
    if io_or_string.kind_of? String
      io_or_string.extend IOString
    end
    
    if io_or_string.respond_to? :read
      result = io_or_string.read(size)
      
    elsif io_or_string.nil?
      raise DataError.new("Perhaps DATA has ended? check your FHP.", io_or_string)
    else
      raise "Unknown source: #{io_or_string.inspect}"
    end
    return result
  end
  
  extend self
end
