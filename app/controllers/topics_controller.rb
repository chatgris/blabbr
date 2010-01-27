class TopicsController < ApplicationController
  before_filter :users_list, :only => [:new, :edit, :create]

  def index
    @topics = Topic.all('subscribers.nickname' => current_user.nickname)
  end
  
  def show
    @topic = Topic.find_by_permalink(params[:id])
    @posts = Post.all(:topic_id => @topic.id)
  end
  
  def new
    @topic = Topic.new
    @post = Post.new
  end
  
  def create
    @topic = Topic.new_by_params(params[:topic], current_user)
    params[:post][:creator] = current_user.nickname
    params[:post][:user_id] = current_user.id.to_s
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
    @topic = Topic.find_by_permalink(params[:id])
    @post = Post.first('created_at' => @topic.created_at)
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
    @topic = Topic.find(params[:id])
    @topic.destroy
    flash[:notice] = "Successfully destroyed topic."
    redirect_to topics_url
  end
  
  protected
  
  def users_list
    @users = User.users_except_creator(current_user.id)
  end
  
end
