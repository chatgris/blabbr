# encoding: utf-8

module Blabbr
  class Home < Sinatra::Base
    Mongoid.load!("config/mongoid.yml")
    helpers AuthentificationHelpers
    helpers Sinatra::Sprockets::Helpers
    use Authentification
    set :views, Pathname.new(settings.root).join('..', 'views')

    include Barristan::Acl.new {|acl|
      acl.can Blabbr::Home, :index do |app, user|
        !!user
      end
    }

    get '/' do
      guard self.class, :index, current_user do |guarded|
        guarded.authorized { erb :index }
        guarded.forbidden  { erb :login }
      end
    end

  end
end
