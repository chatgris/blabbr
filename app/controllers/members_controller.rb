class MembersController < ApplicationController

  before_filter :get_current_topic_for_creator

  def create
    if @topic.new_member(params[:nickname])
      flash[:notice] = t('member.add_success', :name => params[:nickname])
    else
      flash[:error] = t('member.not_find')
    end
    redirect_to topic_path(@topic.permalink)
  end

  def destroy
    if @topic.rm_member!(params[:id])
      flash[:notice] = t('member.remove_success', :name => params[:id])
    else
      flash[:error] = t('member.not_find')
    end
    redirect_to topic_path(@topic.permalink)
  end

  protected

  def get_current_topic_for_creator
    @topic = Topic.criteria.id(params[:topic_id]).and('creator' => current_user.nickname).first
    unless @topic
      flash[:error] = t('topic.not_auth')
      redirect_to :back
    end
  end

end
