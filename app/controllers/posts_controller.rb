class PostsController < ApplicationController

  before_filter :get_current_topic_for_member

  def edit
    @post = @topic.posts.criteria.id(params[:id]).first
  end

  def create
      if @topic.new_post(Post.new(:user_id => current_user.id, :body => params[:post][:body]))
        flash[:notice] = t('post.success')
      else
        flash[:error] = t('post.error')
      end
    redirect_to :back
  end

  protected

  def get_current_topic_for_member
    @topic = Topic.by_permalink(params[:topic_id]).by_subscribed_topic(current_user.nickname).first
    unless @topic
      flash[:error] = t('topic.not_auth')
      redirect_to :back
    end
  end

end
