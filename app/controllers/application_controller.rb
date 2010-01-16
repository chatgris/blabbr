class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :current_user
  
  protected
 
  def current_user
    @current_user = User.find(session[:current_user])
  end

end
