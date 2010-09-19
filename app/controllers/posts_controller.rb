class PostsController < ApplicationController

  before_filter :get_current_topic_for_member
  before_filter :get_smilies, :only => [:create, :show]
  after_filter :reset_unread_posts, :only => [:show]
  after_filter :reset_cache, :only => ['update']
  respond_to :html, :js

  def show
    @post = @topic.posts.criteria.id(params[:id]).first
  end

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
      Pusher[@topic.permalink].trigger('new-post', @post.id)
      flash[:notice] = t('post.success')
    else
      flash[:alert] = t('post.error')
    end
    respond_with(@post, :location => page_topic_path(:id => @topic.permalink, :page => @topic.posts_count / PER_PAGE + 1, :anchor => @post.id.to_s))
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

  def reset_unread_posts
    @topic.reset_unread(current_user.nickname)
  end

  def reset_cache
    expire_fragment "post-#{@post.id}"
  end

end
