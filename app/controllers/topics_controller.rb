# encoding: utf-8
class TopicsController < ApplicationController
  before_filter :get_current_topic_for_creator, :only => [:edit, :update, :destroy]
  before_filter :get_current_topic_for_member, :get_smilies, :only => [:show]
  after_filter :reset_unread_posts, :only => [:show]
  respond_to :html, :json, :js

  def index
    @topics = Topic.by_subscribed_topic(current_user.nickname).desc(:posted_at).paginate :page => params[:page] || nil, :per_page => PER_PAGE_INDEX
    respond_with @topics
  end

  def show
    if @topic.nil?
      flash[:error] = t('topic.not_auth')
      redirect_to topics_path
    else
      @posts = @topic.posts.asc(:created_at).paginate :page => params[:page] || nil, :per_page => PER_PAGE
    end
  end

  def new
    @topic = Topic.new
    @topic.posts.new
  end

  def create
    params[:topic][:user] = current_user
    @topic = Topic.new(params[:topic])

    if @topic.save
      flash[:notice] = t('topics.create.success')
      redirect_to topic_path(@topic.slug) unless request.xhr?
    else
      @post = Post.new(:body => params[:topic][:post])
      render :action => 'new', :collection => @post
    end
  end

  def edit
    if @topic.nil?
      flash[:error] = t('topic.not_auth')
      redirect_to topics_path
    end
  end

  def update
    @topic = Topic.find(params[:id])
    if @topic.update_attributes(params[:topic])
      flash[:notice] = t('topics.update.success')
    else
      flash[:alert] = t('topics.update.fail')
    end
    respond_with(@topic, :location => topic_path(@topic.slug))
  end

  def destroy
    unless @topic.nil?
      @topic.destroy
      redirect_to :back, :notice => t('topic.deleted')
    else
      redirect_to :back, :alert => t('topic.not_auth')
    end
  end

  protected

  def users_list
    @users = User.criteria.excludes(:nickname => current_user.nickname).order_by([[:created_at, :desc]]).flatten
  end

  def reset_unread_posts
    @topic.reset_unread(current_user.nickname) if @topic
  end

  def get_current_topic_for_creator
    @topic = Topic.by_subscribed_topic(current_user.nickname).find(params[:id])
    unless @topic
      redirect_to :back, :alert => t('topic.not_auth')
    end
  end

  def get_current_topic_for_member
    @topic = Topic.by_slug(params[:id]).by_subscribed_topic(current_user.nickname).first
    unless @topic
      redirect_to :back, :alert => t('topic.not_auth')
    end
  end

end
