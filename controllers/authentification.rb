# encoding: utf-8
class Authentification < Sinatra::Base
  set :views, settings.root + '/../views'
  helpers AuthentificationHelpers
  helpers Sinatra::Sprockets::Helpers

  Warden::Manager.serialize_into_session{|user| user.id.to_s }
  Warden::Manager.serialize_from_session{|id| BlabbrCore::Persistence::User.find(id) }

  Warden::Manager.before_failure do |env,opts|
    env['REQUEST_METHOD'] = "POST"
  end

  Warden::Strategies.add(:password) do
    def valid?
      params['user'] && params["user"]['nickname']
    end

    def authenticate!
      if user = BlabbrCore::User.new.authenticate(params['user']['nickname'], params['user']['password'])
        success!(user)
      else
        fail!("Could not log in")
      end
    end
  end

  use Rack::Session::Cookie
  use Warden::Manager do |manager|
    manager.default_strategies :password
    manager.failure_app = self
  end

  post '/login' do
    env['warden'].authenticate!
    redirect "/"
  end

  post '/unauthenticated' do
    #status 401
    erb :login
  end

  post '/logout' do
    env['warden'].logout
    redirect '/'
  end

end
