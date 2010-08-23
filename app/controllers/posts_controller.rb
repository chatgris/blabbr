class PostsController < ApplicationController

  before_filter :get_current_topic_for_member

  def edit
    @post = @topic.posts.criteria.id(params[:id]).first
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      flash[:notice] = t('posts.update.success')
      redirect_to :back
    else
      render :action => 'edit'
    end
  end

  def create
    @post = Post.new(:user_id => current_user.id, :body => params[:post][:body])
    @post.topic = @topic
    if @post.save
      flash[:notice] = t('post.success')
    else
      flash[:error] = t('post.error')
    end
    redirect_to :back
  end

  def destroy
    @post = Post.criteria.id(params[:id]).and(:user_id => current_user.id).first
    if @post
      @post.delete!
      redirect_to :back, :notice => t('posts.delete_success')
    else
      redirect_to :back
      flash[:error] = t('posts.delete_unsuccess')
    end

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
