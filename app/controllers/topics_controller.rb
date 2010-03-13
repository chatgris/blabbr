class TopicsController < ApplicationController
  before_filter :users_list, :only => [:new, :edit, :create]
  before_filter :redirect_if_no_logged

  def index
    @topics = Topic.paginate :page => params[:page], :per_page => 10, 'subscribers.nickname' => @current_user.nickname, :order => 'created_at DESC'
  end
  
  def show
    @topic = Topic.first(:permalink => params[:id], 'subscribers.nickname' => @current_user.nickname)
    if @topic.nil?
      flash[:error] = "You're not authorised to view this page"
      redirect_to topics_path
    else
      @posts = Post.paginate :page => params[:page], :per_page => 50, :topic_id => @topic.id, :order => 'created_at ASC'
    end
  end
  
  def new
    @topic = Topic.new
    @post = Post.new
  end
  
  def create
    @topic = Topic.new_by_params(params[:topic], @current_user)
    params[:post][:user_id] = @current_user.id
    @topic.posts.create(params[:post])
    
    if @topic.save
      flash[:notice] = "Successfully created topic."
      redirect_to topic_path(@topic.permalink)
    else
      @post = Post.new(:content => params[:post][:content])
      render :action => 'new', :collection => @post
    end
  end
  
  def edit
    @topic =Topic.first(:permalink => params[:id], 'creator' => @current_user.nickname)
    unless @topic.nil?
      @post = Post.first('created_at' => @topic.created_at)
    else
      flash[:error] = "You're not authorised to view this page"
      redirect_to topics_path
    end
  end
  
  def update
    @topic = Topic.find(params[:id])
    @post = Post.first('created_at' => @topic.created_at)
    if Topic.update_subscribers(params[:topic], @topic) && @post.update_attributes(params[:post])
      flash[:notice] = "Successfully updated topic."
      redirect_to topic_path(@topic.permalink)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @topic =Topic.first(:permalink => params[:id], 'creator' => @current_user.nickname)
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
    @users = User.users_except_creator(@current_user.id)
  end
  
end
