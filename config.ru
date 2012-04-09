# encoding: utf-8
require 'bundler'

Bundler.require

require './blabbr'

run Blabbr

map '/assets' do
  run Sinatra::Sprockets.environment
end
