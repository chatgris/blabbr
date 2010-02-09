class PostsController < ApplicationController

  def create
    @topic = Topic.find(params[:topic_id])
    params[:post][:user_id] = @current_user.id
#    params[:post][:content] =  CGI.escapeHTML(params[:post][:content])
    @post = @topic.posts.create!(params[:post])
    Topic.increment(@topic.id, :posts_count => 1)
    User.increment(@current_user.id, :posts_count => 1)
    respond_to do |format|
      format.html { redirect_to topic_path(@topic.permalink) }
      format.mobile { redirect_to topic_path(@topic.permalink) }
      format.js 
    end
  end

end
