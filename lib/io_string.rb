require 'stringio'

module IOString
  
  module String
    def io
      @__io ||= StringIO.new(self)
    end
  end
  
  module IO
    def io
      self
    end
  end
  
end

class String
  include IOString::String
end

class StringIO
  include IOString::IO
end

class IO
  include IOString::IO
end
