# CCSDS Unsegmented Time Code


module CCSDS
  module CUC
    
    # def cuc_time time
    #   secs, msecs = time.to_f.divmod(1) # split integer and fractional parts
    #   msecs = (msecs * 256).to_i
    #   [secs, msecs].pack('xN C') # cut off first byte: "@" skips a byte
    # end
    # 
    # def self.cuc_time_parse cuc
    #   secs, msecs = (0.chr + cuc).unpack('xN C')
    #   time = secs + (msecs / 256.0)
    #   Time.at(time)
    # end
    
    class << self
      # coarse are seconds
      # fine are milliseconds muliplied for 256
      def parse coarse, fine
        secs, usecs = coarse, ((fine * 15.0) / 1_000_000.0)
        Time.at(secs + usecs)
      end
    end
    
  end
end