require 'logger'

module WorldLogger
  def self.logger
    if @logger.nil?
      @logger ||= Logger.new($stdout)
      @logger.level = Logger::ERROR
    end
    
    @logger
  end
  
  class NoRaiseObject
    def method_missing name, *args, &block
      return self
    end
  end
  
  def logger
    return @__no_raise_object ||= NoRaiseObject.new if @__logger_disabled
    
    if self.class.const_defined? :Rails
      Rails.logger
    else
      WorldLogger.logger
    end
  end
  
  def disable_logger!
    @__logger_disabled = true
  end
  
  def enable_logger!
    @__logger_disabled = false
  end
  
end

Object.send :include, WorldLogger
