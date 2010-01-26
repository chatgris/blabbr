class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  helper_method :current_user
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :current_user
  
  protected
 
  def current_user
    User.find(session[:current_user])
  end

end
