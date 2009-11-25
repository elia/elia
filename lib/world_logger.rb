require 'logger'

module WorldLogger
  def self.logger
    if @logger.nil?
      @logger ||= Logger.new($stdout)
      @logger.level = Logger::ERROR
    end
    
    @logger
  end
  
  
  def logger
    if self.class.const_defined? :Rails
      Rails.logger
    else
      WorldLogger.logger
    end
  end
  
end

Object.send :include, WorldLogger
