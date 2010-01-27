class PostsController < ApplicationController

  def create
    @topic = Topic.find(params[:topic_id])
    params[:post][:creator] = current_user.nickname
    @post = @topic.posts.create!(params[:post])
    respond_to do |format|
      format.html { redirect_to topic_path(@topic.permalink) }
      format.js 
    end
  end

end
