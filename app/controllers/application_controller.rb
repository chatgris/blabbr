class ApplicationController < ActionController::Base
  helper :all
  helper_method :current_user, :logged_user?
  protect_from_forgery
  before_filter :instantiate_controller_and_action_names, :redirect_if_no_logged, :current_user
  
  protected
 
  def current_user
    @current_user = User.find(session[:current_user])
  end
  
  def logged_user?
    session[:current_user]
  end
  
  def redirect_if_no_logged
    unless @current_controller == 'sessions' || logged_user?
      flash[:error] = "You're not authorised to view this page"
      redirect_to login_path
    end
  end
  
  def instantiate_controller_and_action_names
    @current_action = action_name
    @current_controller = controller_name
  end

end
