# encoding: utf-8
require 'sinatra/base'

# App
Dir[File.dirname(__FILE__) + "/app/**/*.rb"].each {|file| require file }

class Blabbr < Sinatra::Base
  use Authentification
  helpers AuthentificationHelpers
  set :server, :thin
  set :views, settings.root + '/app/views'

  get '/' do
    erb current_user.nil? ? :login : :index
  end
end
