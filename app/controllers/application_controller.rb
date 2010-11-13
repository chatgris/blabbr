class ApplicationController < ActionController::Base
  layout :layout_by_resource
  protect_from_forgery
  helper_method :creator?
  after_filter :flash_to_headers

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

end
