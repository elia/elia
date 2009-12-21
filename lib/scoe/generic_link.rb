require 'scoe/server' # A Scoe specific TCPServer
require 'errno_knows'

module Scoe
  
  ##
  # A generic Scoe link class, each subclass should implement the 
  # main_server_loop method which should contain the server logic.
  class GenericLink
    
    attr_accessor :config
    attr_reader :server
  
    # Takes a hash of +options+:
    #   
    #   Scoe.new :port => 9000
    # 
    # See single link classes for different available options.
    # This options are then passed to ScoeServer and to ScoeSocket.
    # 
    def initialize options = {:port => 9000}
      @config = options
    end
    
    # Starts the Scoe server and the thread which sens messages to MTP.
    def start
      start_server
      start_consumer
    end
  
    # Starts the Scoe TCP server.
    def start_server
      raise "Already Started!" if @server
      logger.info "Starting ScoeServer at port #{config[:port]}"
      @server = ScoeServer.new( config[:port].to_i )
      @server.config = @config
      @server
    end
  
    # Starts the Thread which sends messages to the MTP.
    def start_consumer
      raise "Already Started!" if @consumer
      Thread.abort_on_exception = true
      @consumer = Thread.new do
        loop do # accepting
          logger.info "#{self.class} waiting for MTP on port #{config[:port]}!"
          socket = @server.accept
          logger.info "#{self.class} connected to MTP!"
        
          logger.debug { "#{self.class} starting main_server_loop!" }
          
          begin
            main_server_loop(socket)
          rescue
            logger.error $!
            # break if is a Errno error!
            Errno.knows?($!) ? break : raise
          end
          logger.debug { "#{self.class} disconnected." }
        
        end
      end
    end
    
    def main_server_loop
      raise NotImplementedError
    end
    
  end
end