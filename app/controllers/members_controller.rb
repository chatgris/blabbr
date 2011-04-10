class MembersController < ApplicationController

  before_filter :get_current_topic_for_creator
  respond_to :html, :js

  def create
    if @topic.new_member(params[:nickname])
      flash[:notice] = t('members.create.success', :name => params[:nickname])
    else
      flash[:alert] = t('members.create.fail')
    end
    respond_with(@topic, :location => topic_path(@topic.slug))
  end

  def destroy
    if @topic.rm_member!(params[:id])
      flash[:notice] = t('members.destroy.success', :name => params[:nickname])
    else
      flash[:alert] = t('members.destroy.fail')
    end
    respond_with(@topic, :location => topic_path(@topic.slug))
  end

  protected

  def get_current_topic_for_creator
    @topic = Topic.for_creator(current_user.nickname).find(params[:topic_id])
    unless @topic
      redirect_to :back, :alert => t('topics.not_auth')
    end
  end

end
