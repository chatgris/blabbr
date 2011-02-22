class ApplicationController < ActionController::Base
  layout :layout_by_resource
  protect_from_forgery
  helper_method :creator?
  before_filter :redirect_to_https
  after_filter :flash_to_headers, :set_user_preferences

  protected

  def creator?(user)
    user == current_user.nickname
  end

  def get_smilies
    @smilies = Smiley.all.flatten
  end

  def layout_by_resource
    if devise_controller?
      "sessions"
    else
      "application"
    end
  end

  def flash_to_headers
    flash.discard if request.xhr?
  end

  def redirect_to_https
    redirect_to :protocol => "https://" unless (request.ssl? || ENV['SSL'].nil?)
  end


  def set_user_preferences
    if current_user
      cookies[:audio] = current_user.audio unless cookies[:audio]
      cookies[:user_id] = current_user.id unless cookies[:user_id]
    end
  end

end
