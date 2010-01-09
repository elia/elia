require 'sass'
require 'sass/plugin'

Sass::Plugin.instance_eval {
  @options[:load_paths] ||= []
  @options[:load_paths] << File.join( File.dirname(__FILE__), 'sass_support' )
}
