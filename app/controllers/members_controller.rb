class MembersController < ApplicationController

  before_filter :get_current_topic_for_creator
  respond_to :html, :js

  def create
    if @topic.new_member(params[:nickname])
      flash[:notice] = t('member.add_success', :name => params[:nickname])
    else
      flash[:alert] = t('member.not_find')
    end
    respond_with(@topic, :location => topic_path(@topic.slug))
  end

  def destroy
    if @topic.rm_member!(params[:id])
      redirect_to topic_path(@topic.slug), :notice => t('member.remove_success', :name => params[:id])
    else
      redirect_to topic_path(@topic.slug), :alert => t('member.not_find')
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
