module Ini
  def parse_ini(input)
    hash = {}
    current_section = nil
    
    input.each_line do |line|
      line = line.sub(/\;.*$/, '').strip.chomp.strip # strip comments
      next if line.strip.empty?
      
      if line.strip =~ /\[([^\]]+)\]/
        current_section = $1.downcase
        hash[current_section] ||= {}
      else
        key, value = line.split('=')
        
        value.strip!
        value = case value
                when /0x[\da-f]/i     : value.hex
                when /^[\+\-]?\d+$/   : value.to_i
                when /^\"(.*)\"$/     : $1
                else value
                end
        hash[current_section][key.downcase] = value
      end
    end
    
    hash
  end
  
  extend self
end
