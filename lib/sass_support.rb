require 'sass'
require 'sass/plugin'

Sass::Plugin.options[:load_paths] ||= []
Sass::Plugin.options[:load_paths] << File.dirname(__FILE__) + '/sass_support'
