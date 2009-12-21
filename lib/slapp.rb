#!/usr/bin/env arch -i386 ruby
# coding: utf-8


# A WxRuby Shoes-like DSL
# 
#   #!/usr/bin/env arch -i386 ruby
#   require 'rubygems'
#   require 'slapp'
#   
#   Slapp.app {
#     frame :title => "Wow!" do
#       button :start_stop, :caption => "start/stop"
#     end
#   }
# 
# 
# 
# OSX Snow Leopard users see: http://exceptionisarule.blogspot.com/2009/11/building-wxruby-201-on-snow-leopard.html
# 
module Slapp
  require 'wx'
  module Sugar
    include Wx
    def frame options = {}, &block
      elements[:frame] = Frame.new(nil, -1, options[:title])
      block.call
      elements[:frame].show
      return elements[:frame]
    end
  
    def elements
      @elements ||= {}
    end
  
    def button name, options = {}
      elements[name] ||= Button.new elements[:frame], -1, options[:caption]
    end
  end
  
  def self.app &block
    Wx::App.app &block
    Wx::App.run
  end
end

class Wx::App
  include Slapp::Sugar
  def on_init
    self.instance_eval &self.class.app
  end
  def self.app &block
    if block_given?
    then @on_init_proc = block
    else @on_init_proc
    end
  end
  def run
    new.main_loop
  end
end
