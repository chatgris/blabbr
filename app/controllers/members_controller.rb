class MembersController < ApplicationController

  before_filter :get_current_topic_for_member

  def create

  end

  def destroy

  end

  protected

  def get_current_topic_for_creator
    @topic = Topic.criteria.id(params[:id]).and('creator' => current_user.nickname).first
    unless @topic
      flash[:error] = t('topic.not_auth')
      redirect_to :back
    end
  end

end
