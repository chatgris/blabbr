class TopicsController < ApplicationController
  before_filter :authorize
  before_filter :get_current_topic_for_creator, :only => [:edit, :update, :destroy, :add_member, :remove_member]
  before_filter :get_current_topic_for_member, :only => [:show, :add_post]
  after_filter :reset_unread_posts, :only => [:show]

  def index
    @topics = Topic.by_subscribed_topic(current_user.nickname).order_by([[:updated_at, :desc]]).paginate :page => params[:page] || nil, :per_page => 10
  end

  def show
    if @topic.nil?
      flash[:error] = t('topic.not_auth')
      redirect_to topics_path
    else
      @posts = @topic.posts.all.order_by([[:created_at, :desc]]).paginate :page => params[:page] || nil, :per_page => 50
    end
  end

  def new
    @topic = Topic.new
  end

  def create
    params[:topic][:creator] = current_user.nickname
    @topic = Topic.new(params[:topic])

    if @topic.save
      flash[:notice] = "Successfully created topic."
      redirect_to topic_path(@topic.permalink)
    else
      @post = Post.new(:body => params[:topic][:post])
      render :action => 'new', :collection => @post
    end
  end

  def edit
    unless @topic.nil?
      @post = @topic.posts('created_at' => @topic.created_at).first
    else
      flash[:error] = t('topic.not_auth')
      redirect_to topics_path
    end
  end

  def add_member
    if @topic.new_member(params[:nickname])
      flash[:notice] = t('member.add_success', :name => params[:nickname])
    else
      flash[:error] = t('member.not_find')
    end
    redirect_to topic_path(@topic.permalink)
  end

  def remove_member
    if @topic.rm_member!(params[:nickname])
      flash[:notice] = t('member.remove_success', :name => params[:nickname])
    else
      flash[:error] = t('member.not_find')
    end
    redirect_to topic_path(@topic.permalink)
  end

  def add_post
    if @topic.new_post(Post.new(:user_id => current_user.id, :body => params[:body]))
      flash[:notice] = t('post.success')
    else
      flash[:error] = t('post.error')
    end
    redirect_to :back
  end


  def update
    @topic = Topic.find(params[:id])
    if @topic.update_attributes(params[:topic])
      flash[:notice] = "Successfully updated topic."
      redirect_to topic_path(@topic.permalink)
    else
      render :action => 'edit'
    end
  end

  def destroy
    unless @topic.nil?
      @topic.destroy
      flash[:notice] = "Successfully destroyed topic."
    else
      flash[:error] = "You're not authorised to view this page"
    end
    redirect_to topics_url
  end

  protected

  def users_list
    @users = User.criteria.excludes(:nickname => current_user.nickname).order_by([[:created_at, :desc]]).flatten
  end

  def reset_unread_posts
    if @topic
      @topic.reset_unread(current_user.nickname)
      @topic.save
    end
  end

  def get_current_topic_for_creator
    @topic = Topic.criteria.id(params[:id]).and('creator' => current_user.nickname).first
    unless @topic
      flash[:error] = t('topic.not_auth')
      redirect_to :back
    end
  end

  def get_current_topic_for_member
    @topic = Topic.by_permalink(params[:id]).by_subscribed_topic(current_user.nickname).first
    unless @topic
      flash[:error] = t('topic.not_auth')
      redirect_to :back
    end
  end

end
