# encoding: utf-8
require 'sinatra/base'

class Blabbr < Sinatra::Base
  set :server, :thin
  set :views, settings.root + '/app/views'

  get '/' do
    erb :index
  end
end
