# encoding: utf-8
module AuthentificationHelpers
  def current_user
    env['warden'].user
  end
end
