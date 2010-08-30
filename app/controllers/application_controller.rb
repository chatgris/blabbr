class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :current_user, :logged_in?
  helper_method :current_user, :logged_in?, :creator?

  protected

  def current_user
    @current_user ||= User.find(session[:current_user]) if session[:current_user]
  end

  def logged_in?
    session[:current_user]
  end

  def creator?(user)
    user == current_user.nickname
  end

  def authorize
    unless logged_in?
      redirect_to login_path
    end
  end

  def get_smilies
    @smilies = Smiley.all.flatten
  end

end
