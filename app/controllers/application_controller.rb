# encoding: utf-8
class ApplicationController < ActionController::Base
  layout :layout_by_resource
  protect_from_forgery
  helper_method :creator?
  before_filter :redirect_to_https, :set_user_time_zone
  after_filter :flash_to_headers

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to :back, :alert => t('cancan.not_authorize')
  end

  protected

  def creator?(user)
    user == current_user.nickname
  end

  def get_smilies
    smilies = Rails.cache.read 'smilies_list'
    if smilies
      @smilies = JSON.parse(smilies)
    else
      @smilies = Smiley.all.flatten.to_json
      Rails.cache.write('smilies_list', @smilies)
    end
  end

  def get_topic
    @topic = Topic.by_slug(params[:id]).first
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

  def set_user_time_zone
    Time.zone = current_user.time_zone if current_user && current_user.time_zone
  end

end
