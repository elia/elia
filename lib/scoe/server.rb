require 'socket'
require 'ccsds'

module Scoe
  class ScoeServer < TCPServer
    module ScoeSocket
      # see Scoe.new
      def config= config = {}
        @config = config
      end

      # see Scoe.new
      def config
        @config || {}
      end
      
      
      
      
      # # SETUP LINK
      # 
      # def get_setup_command
      #   
      # end
      
      
      
      
      # TM LINK
      
      # Takes an Hash and sends it to the MTP transforming keys in RPIDS 
      # according to SCOESocket#config.
      def send_rpid_message *args
        self << prepare_rpid_message(*args)
      end


      private

      def prepare_rpid_message params = {}
        map = 'N' # start with packing the 
        payload = params.to_a.map do |(key, param)|
          raise "rpid not configured for #{key.inspect}, I only know about #{config[:rpids].inspect}" unless config[:rpids][key]

          # add to the map the pack rule for this parameter
          map << "N#{ config[:rpids][key][:pack] }"

          [config[:rpids][key][:rpid], param]
        end.flatten

        # add to head the number of parameters
        payload = payload.unshift(params.size)

        # pack the payload into a bit string
        payload = payload.pack(map)

        @count ||= 0
        packet = Ccsds.generate!( config[:apid], @count, payload )
        @count += 1
        packet
      end

    end

    # see Scoe.new
    def config= config = {}
      @config = config
    end

    # Calls TCPServer accept but returns a socket extended with SCOESocket.
    def accept
      socket = super
      socket.extend SCOESocket
      socket.config = @config

      return socket
    end
  end
end
