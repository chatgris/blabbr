# encoding: utf-8
require 'sinatra/base'

Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db('blabbr_dev')
  config.identity_map_enabled = true
end

# App
require_relative 'lib/blabbr_core'
Dir[File.dirname(__FILE__) + "/**/*.rb"].each {|file| require file }

class Blabbr < Sinatra::Base
  use Authentification
  helpers AuthentificationHelpers
  set :server, :thin

  get '/' do
    erb current_user.nil? ? :login : :index
  end
end
