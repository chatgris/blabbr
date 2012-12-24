# encoding: utf-8

require_relative "../models/connections"

module Blabbr
  class Realtime < Sinatra::Base
    helpers AuthentificationHelpers
    use Authentification
    connections = Connections.new

    get '/', provides: 'text/event-stream' do
      if current_user
        stream(:keep_open) {|connection| connections.join(current_user, connection) }
      end
    end

  end
end
