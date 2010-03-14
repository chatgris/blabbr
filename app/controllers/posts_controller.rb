class PostsController < ApplicationController
  
  before_filter :redirect_if_no_logged
  after_filter :increment_posts_count, :only => [:create]

  def create
    @topic = Topic.increment(Topic.find(params[:topic_id]))
    Topic.add_post(@topic, @current_user.nickname, params[:post][:content])
    @topic.save
    respond_to do |format|
      format.html { redirect_to topic_path(@topic.permalink) }
      format.mobile { redirect_to topic_path(@topic.permalink) }
      format.js 
    end
  end
  
  protected
  
  def increment_posts_count
    User.increment(@current_user)
  end
  
end
