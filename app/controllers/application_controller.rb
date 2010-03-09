class ApplicationController < ActionController::Base
  helper :all
  helper_method :current_user, :logged_user?, :mobile_device?
  protect_from_forgery
  before_filter :instantiate_controller_and_action_names, :redirect_if_no_logged, :current_user, :set_locale, :prepare_for_mobile
  
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
  
  def set_locale 
    I18n.locale = @current_user.locale if @current_user
  end 
  
  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /Mobile|webOS/
    end
  end

  def prepare_for_mobile
    session[:mobile_param] = params[:mobile] if params[:mobile]
    request.format = :mobile if mobile_device?
  end

end

