require 'sass'
require 'sass/plugin'


module Sass
  ELIA_SASS_SUPPORT = File.join( File.dirname(__FILE__), 'sass_support' )
end

[
  # Sass::Engine::DEFAULT_OPTIONS, 
  Sass::Plugin.options
].each do |hash|
  hash[:load_paths] ||= ["."]
  hash[:load_paths] << File.join( Sass::ELIA_SASS_SUPPORT )
end
