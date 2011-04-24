# encoding: utf-8
class TopicsController < ApplicationController
  before_filter :get_current_topic_for_creator, :only => [:edit, :update, :destroy]
  before_filter :get_current_topic_for_member, :only => [:show]
  before_filter :get_smilies, :only => [:show, :create]
  after_filter :reset_unread_posts, :only => [:show]
  respond_to :html, :json, :js

  def index
    @topics = Topic.by_subscribed_topic(current_user.nickname).desc(:posted_at).paginate :page => params[:page] || nil, :per_page => PER_PAGE_INDEX
  end

  def show
     @posts = @topic.posts.asc(:created_at).paginate :page => params[:page] || nil, :per_page => PER_PAGE
    respond_with @posts
  end

  def new
    @topic = Topic.new
    @topic.posts.new
  end

  def create
    @topic = Topic.new(params[:topic])
    @topic.user = current_user

    if @topic.save
      flash[:notice] = t('topics.create.success')
      @posts = @topic.posts.paginate
    else
      flash[:alert] = t('topics.create.fail')
    end
    respond_with(@topic, :location => topic_path(@topic))
  end

  def edit
  end

  def update
    if @topic.update_attributes(params[:topic])
      flash[:notice] = t('topics.update.success')
    else
      flash[:alert] = t('topics.update.fail')
    end
    respond_with(@topic, :location => topic_path(@topic))
  end

  def destroy
    if @topic.delete!
      flash[:notice] = t('topics.delete.success')
    else
      flash[:alert] = t('topics.delete.fail')
    end
    respond_with(@topic, :location => topics_path)
  end

  protected

  def users_list
    @users = User.criteria.excludes(:nickname => current_user.nickname).order_by([[:created_at, :desc]]).flatten
  end

  def reset_unread_posts
    @topic.reset_unread(current_user.nickname) if @topic
  end

  def get_current_topic_for_creator
    @topic = Topic.by_slug(params[:id]).for_creator(current_user.nickname).first
    unless @topic
      redirect_to :back, :alert => t('topics.not_auth')
    end
  end

  def get_current_topic_for_member
    @topic = Topic.by_slug(params[:id]).by_subscribed_topic(current_user.nickname).first
    unless @topic
      redirect_to :back, :alert => t('topics.not_auth')
    end
  end

end
