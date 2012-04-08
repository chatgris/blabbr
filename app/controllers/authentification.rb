# encoding: utf-8
class Authentification < Sinatra::Base
  helpers AuthentificationHelpers
  Warden::Manager.serialize_into_session{|user| user}
  Warden::Manager.serialize_from_session{|id| id }

  Warden::Manager.before_failure do |env,opts|
    env['REQUEST_METHOD'] = "POST"
  end

  Warden::Strategies.add(:password) do
    def valid?
      params['user'] && params["user"]['login']
    end

    def authenticate!
      if params['user'] && params['user']['login'] == 'me' && params['user']['password'] == 'password'
        user = {login: 'me'}
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
