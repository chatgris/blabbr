class PostsController < ApplicationController
  before_filter :get_current_topic_for_creator, :only => [:destroy]
  before_filter :get_current_topic_for_member, :except => [:destroy]
  before_filter :get_smilies, :only => [:show, :update]
  after_filter :reset_unread_posts, :only => [:show]
  after_filter :reset_cache, :only => ['update']
  respond_to :html, :js

  def show
    @post = @topic.posts.find(params[:id])
  end

  def edit
    @post = @topic.posts.criteria.id(params[:id]).first
  end

  def update
    @post = @topic.posts.find(params[:id])
    if @post.update_attributes(params[:post])
      flash[:notice] = t('posts.update.success')
    else
      flash[:alert] = t('posts.update.fail')
    end
    respond_with(@post, :location => :back)
  end

  def create
    @post = Post.new(:creator => current_user, :t => @topic, :body => params[:post][:body])
    @post.topic = @topic
    if @post.save
      flash[:notice] = t('posts.create.success')
      # TODO : redis to the resque
      begin
        if Pusher.key
          Pusher[@topic.slug].trigger('new-post', {:id => @post.id, :user_id => @post.user_id})
          Pusher[@topic.slug].trigger('index', true)
        end
      rescue Pusher::Error => e
        flash[:error] = e
      end
    else
      flash[:alert] = t('posts.create.error')
    end
    respond_with(@post, :location => page_topic_path(:id => @topic.slug, :page => @topic.posts_count / PER_PAGE + 1, :anchor => @post.id.to_s))
  end

  def destroy
    @post = Post.criteria.id(params[:id]).and(:user_id => current_user.id).first
    if @post
      @post.delete!
      flash[ :notice] = t('posts.delete_success')
    else
      flash[:alert] = t('posts.delete_unsuccess')
    end
    respond_with(@post, :location => :back)

  end

  protected

  def get_current_topic_for_member
    @topic = Topic.by_slug(params[:topic_id]).by_subscribed_topic(current_user.nickname).first
    unless @topic
      redirect_to :back, :alert => t('topic.not_auth')
    end
  end

  def get_current_topic_for_creator
    @topic = Topic.criteria.id(params[:topic_id]).by_subscribed_topic(current_user.nickname).first
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
