class MembersController < ApplicationController

  before_filter :get_current_topic_for_creator

  def create
    if @topic.new_member(params[:nickname])
      redirect_to topic_path(@topic.permalink), :notice => t('member.add_success', :name => params[:nickname])
    else
      redirect_to topic_path(@topic.permalink), :alert => t('member.not_find')
    end
  end

  def destroy
    if @topic.rm_member!(params[:id])
      redirect_to topic_path(@topic.permalink), :notice => t('member.remove_success', :name => params[:id])
    else
      redirect_to topic_path(@topic.permalink), :alert => t('member.not_find')
    end
  end

  protected

  def get_current_topic_for_creator
    @topic = Topic.criteria.id(params[:topic_id]).and('creator' => current_user.nickname).first
    unless @topic
      redirect_to :back, :alert => t('topic.not_auth')
    end
  end

end
