# encoding: utf-8
require 'sinatra/base'

# App
require_relative 'lib/blabbr_core'
['helpers', 'models', 'controllers'].each do |dir|
  Dir[File.dirname(__FILE__) + "/#{dir}/**/*.rb"].each {|file| require file }
end
