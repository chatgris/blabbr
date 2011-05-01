class PostsController < ApplicationController
  before_filter :get_current_topic_for_member, :only => [:show, :create]
  before_filter :get_current_topic_for_action, :only => [:edit, :update, :destroy]
  before_filter :get_post_for_creator, :only => [:edit, :update, :destroy]
  before_filter :get_smilies, :only => [:show, :update, :create]
  after_filter :reset_unread_posts, :only => [:show]
  after_filter :reset_cache, :only => [:update, :create]
  respond_to :html, :js

  def show
    @post = @topic.posts.find(params[:id])
  end

  def edit
  end

  def update
    if @post.update_attributes(params[:post])
      flash[:notice] = t('posts.update.success')
    else
      flash[:alert] = t('posts.update.fail')
    end
    respond_with(@post, :location => :back)
  end

  def create
    @post = Post.new(params[:post])
    @post.creator = current_user
    @post.topic = @topic
    if @post.save
      flash[:notice] = t('posts.create.success')
    else
      flash[:alert] = t('posts.create.fail')
    end
    respond_with(@post, :location => page_topic_path(:id => @topic, :page => @topic.posts_count / PER_PAGE + 1, :anchor => @post.id.to_s))
  end

  def destroy
    if @post.delete!
      flash[ :notice] = t('posts.destroy.success')
    else
      flash[:alert] = t('posts.destroy.fail')
    end
    respond_with(@post, :location => :back)

  end

  protected

  def get_post_for_creator
    @post = @topic.posts.for_creator(current_user.nickname).find(params[:id])
    unless @post
      redirect_to :back, :alert => t('posts.not_auth')
    end
  end

  def get_current_topic_for_action
    @topic = Topic.by_slug(params[:topic_id]).by_subscribed_topic(current_user.nickname).first
    unless @topic
      redirect_to :back, :alert => t('posts.not_auth')
    end
  end

  def get_current_topic_for_member
    @topic = Topic.by_slug(params[:topic_id]).by_subscribed_topic(current_user.nickname).first
    unless @topic
      redirect_to :back, :alert => t('topics.not_auth')
    end
  end

  def reset_unread_posts
    @topic.reset_unread(current_user.nickname)
  end

  def reset_cache
    expire_action(:controller => 'topics', :action => 'show', :id => @topic.slug, :page => @post.page, :format => params['format'])
  end

end
