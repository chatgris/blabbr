# encoding: utf-8
class TopicsController < ApplicationController
  before_filter :get_topic, :only => [:show, :edit, :update, :destroy, :add_member, :rm_member]
  before_filter :get_smilies, :only => [:show, :create]
  after_filter :reset_unread_posts, :only => [:show]
  respond_to :html, :json, :js
  authorize_resource
  caches_action :show, :if => Proc.new { |c| c.request.format.json? }

  def index
    @topics = Topic.by_subscribed_topic(current_user.nickname).desc(:posted_at).paginate :page => params[:page] || nil, :per_page => PER_PAGE_INDEX
    respond_with(@topics)
  end

  def show
    @posts = @topic.posts.asc(:created_at).paginate :page => params[:page] || nil, :per_page => PER_PAGE
    respond_to do |format|
      format.html
      format.js
      format.json { render :json => { :topic => @topic, :posts => @posts }}
    end

    #respond_with @posts
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

  # Members
  def add_member
    if @topic.add_member(params[:nickname])
      flash[:notice] = t('members.create.success', :name => params[:nickname])
    else
      flash[:alert] = t('members.create.fail')
    end
    respond_with(@topic, :location => topic_path(@topic))
  end

  def rm_member
    if @topic.rm_member!(params[:nickname])
      flash[:notice] = t('members.destroy.success', :name => params[:nickname])
    else
      flash[:alert] = t('members.destroy.fail')
    end
    respond_with(@topic, :location => topic_path(@topic))
  end

  protected

  def users_list
    @users = User.criteria.excludes(:nickname => current_user.nickname).order_by([[:created_at, :desc]]).flatten
  end

  def reset_unread_posts
    @topic.reset_unread(current_user.nickname) if @topic
  end

end
