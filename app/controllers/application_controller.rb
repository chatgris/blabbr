class ApplicationController < ActionController::Base
  layout :layout_by_resource
  protect_from_forgery
  helper_method :creator?

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

end
