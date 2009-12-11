module FileWithBufferedRead
  require 'stringio'
  
  READ_BUFFER_SIZE = 1 << 22
  
  def buffered_read size
    output = read_buffer.read(size)
    until output.size == size or self.eof?
      output << read_buffer.read(size - output.size)
    end
    return output
  end
  
  private
  def buffer_left
    read_buffer.size - read_buffer.pos
  end
  
  def read_buffer
    if @read_buffer.nil? or @read_buffer.eof?
      # logger.debug{ "Buffering #{READ_BUFFER_SIZE} from #{self.inspect} current position: #{self.pos}" }
      @read_buffer = StringIO.new(read(READ_BUFFER_SIZE))
      # logger.debug{ "Buffered #{@read_buffer.size}, EOF:#{self.eof?} current position: #{self.pos}" }
      @buffer_left = @read_buffer.size
    end
    @read_buffer
  end
  
end
