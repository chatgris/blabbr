# encoding: utf-8
require "bundler/setup"
require 'sinatra/base'

Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db('blabbr_dev')
  config.identity_map_enabled = true
end

# App
require_relative 'lib/blabbr_core'
Dir[File.dirname(__FILE__) + "/**/*.rb"].each {|file| require file }

class Blabbr < Sinatra::Base
  helpers AuthentificationHelpers
  helpers Sinatra::Sprockets::Helpers
  use Authentification
  set :server, :thin
  connections = Connections.new

  Sinatra::Sprockets.configure do |config|
    config.app = self

    ['stylesheets', 'javascripts', 'images'].each do |dir|
      config.append_path(File.join('assets', dir))
      config.js_compressor  = Uglifier.new(mangle: false)
      config.css_compressor = false
      config.digest = false
      config.compress = false
      config.debug = false

      config.precompile = ['application.js']
    end
  end

  get '/events', provides: 'text/event-stream' do
    if current_user
      stream(:keep_open) {|connection| connections.join(current_user, connection) }
    end
  end

  get '/' do
    erb current_user.nil? ? :login : :index
  end


end
