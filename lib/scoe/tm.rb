require 'scoe/generic_link'
require 'thread' # for Queue object

module Scoe
  
  # 
  class Tm < GenericLink
    
    # Takes a hash of +options+:
    #   
    #   Scoe::Tm.new  :apid => 101, 
    #                 :port => 9003, 
    #                 :rpids => {
    #                   :crc_errors => {:rpid => 1, :pack => 'N'}, 
    #                   :data_errors => {:rpid => 2, :pack => 'N'}
    #                 },
    # 
    # In which :apid contains the APID used, :port the port on which the MTP
    # will connect and :rpids contains a list of symbol keys associated to a 
    # numeric RPID (Relative PID) and a string to Array#pack the value.
    # 
    # This options are then passed to ScoeServer and to ScoeSocket.
    # 
    def initialize options; super; end
    
    # A the Queue object used to buffer the messages
    def queue
      @queue ||= Queue.new
    end
  
    # Pushes a hash to the Queue which eill be interpreted as RPID key / values
    # and sent to the MTP once is connected.
    def push element
      # queue.clear
      logger.debug { "Pushing message on Scoe queue..." }
      queue.push element
    end
    
    def main_server_loop(socket)
      loop {
        logger.debug { "#{self.class} sending to MTP!" }
        socket.send_rpid_message(queue.pop) rescue puts($!.to_s)
        logger.debug { "#{self.class} sent to MTP!" }
      }
    end
    
    # Send a direct message to ECHO
    def direct element
      logger.debug { "Sending direct message to ECHO..." }
      socket.send_rpid_message(element)
    end
  end
end