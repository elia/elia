require 'scoe/generic_link'
require 'eden_setup'

module Scoe
  class Setup < GenericLink
    
    
    def events
      @events ||= {}
    end
    
    def on event_name, &block
      event_name = event_name.to_sym
      events[event_name] ||= []
      events[event_name] << block
    end
    
    def run_commands_on event_name
      event_name = event_name.to_sym
      callbacks = events[event_name]
      unless callbacks.nil? or callbacks.empty?
        callbacks.each do |callback|
          callback.call
        end
      else
        return false
      end
    end
    
    def main_server_loop(socket)
      Eden.each_packet(socket) do |eden|
        
        if eden.eden_type    == "CMD" and 
           eden.eden_subtype == "EXEC"
          if run_commands_on(eden.data)
            answer = EdenSetup.new 'ok', :answer => 0
          else
            answer = EdenSetup.new "Unknown command, use: #{events.keys.join(', ')}", :answer => 1
          end
          socket << answer.encapsulate
        end
        Thread.pass
      end
    end
    
    
  end
end