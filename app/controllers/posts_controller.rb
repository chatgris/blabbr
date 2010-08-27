class PostsController < ApplicationController

  before_filter :get_current_topic_for_member

  def edit
    @post = @topic.posts.criteria.id(params[:id]).first
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      redirect_to :back, :notice => t('posts.update.success')
    else
      render :action => 'edit'
    end
  end

  def create
    @post = Post.new(:user_id => current_user.id, :body => params[:post][:body])
    @post.topic = @topic
    if @post.save
      redirect_to :back, :notice => t('post.success')
    else
      redirect_to :back, :alert => t('post.error')
    end
  end

  def destroy
    @post = Post.criteria.id(params[:id]).and(:user_id => current_user.id).first
    if @post
      @post.delete!
      redirect_to :back, :notice => t('posts.delete_success')
    else
      redirect_to :back, :alert => t('posts.delete_unsuccess')
    end

  end

  protected

  def get_current_topic_for_member
    @topic = Topic.by_permalink(params[:topic_id]).by_subscribed_topic(current_user.nickname).first
    unless @topic
      redirect_to :back, :alert => t('topic.not_auth')
    end
  end

end
