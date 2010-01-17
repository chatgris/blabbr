class TopicsController < ApplicationController
  before_filter :users_list, :only => [:new, :edit]

  def index
    @topics = Topic.all(:conditions => {'subscribers.nickname' => @current_user.nickname})
  end
  
  def show
    @topic = Topic.find_by_permalink(params[:id])
  end
  
  def new
    @topic = Topic.new
  end
  
  def create
    @topic = Topic.new_by_params(params[:topic], @current_user)
    
    if @topic.save
      flash[:notice] = "Successfully created topic."
      redirect_to topic_path(@topic.permalink)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @topic = Topic.find_by_permalink(params[:id])
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
    @topic = Topic.find(params[:id])
    @topic.destroy
    flash[:notice] = "Successfully destroyed topic."
    redirect_to topics_url
  end
  
  protected
  
  def users_list
    @users = User.users_except_creator(@current_user.id)
  end
  
end
