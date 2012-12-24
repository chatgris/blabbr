# encoding: utf-8
require 'sinatra/base'

# App
require_relative 'lib/blabbr_core'
Dir[File.dirname(__FILE__) + "/**/*.rb"].each {|file| require file }
