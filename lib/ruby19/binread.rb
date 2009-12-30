require 'ruby19'

ruby18 do
  module Binread
    def binread path_or_file_descriptor
      open(path_or_file_descriptor,'rb'){|io| io.read }
    end
  end
  
  IO.extend(Binread)
  File.extend(Binread)
  
  class String
    def encode encoding
      if %w[BINARY ASCII-8BIT].include? encoding
        return self
      else
        super
      end
    end
  end
end
