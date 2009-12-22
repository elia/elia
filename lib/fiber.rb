unless Object.const_defined?(:Fiber)
  
  class Fiber
    class Error < StandardError; end

    def initialize &block
      raise ArgumentError unless block_given?
      
      @block = block
      callcc do |cc|
        @inside = cc
        return
      end
      @var = @block.call self
      @inside = nil
      @outside.call
    end

    def resume
      raise Error, "dead fiber called!" unless @inside
      callcc do |cc|
        @outside = cc
        @inside.call
      end
      @var
    end

    def yield var
      callcc do |cc|
        @var = var
        @inside = cc
        @outside.call
      end
    end
  end
  
end