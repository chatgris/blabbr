# encoding: utf-8
require 'bundler'
Bundler.require
require './blabbr'

Sinatra::Sprockets.configure do |config|
  config.app = Blabbr::Home
  config.css_compressor = false
  config.digest = false
  config.compress = false
  config.debug = false

  config.precompile = ['application.js']
  config.js_compressor  = Uglifier.new(mangle: false)

  ['stylesheets', 'javascripts', 'images'].each do |dir|
    config.append_path(File.join('..', 'assets', dir))
  end
end

stack = Rack::Builder.new do

  map '/assets' do
    run Sinatra::Sprockets.environment
  end

  map '/realtime' do
    run Blabbr::Realtime
  end

  map '/' do
    run Blabbr::Home
  end
end

run stack.to_app
