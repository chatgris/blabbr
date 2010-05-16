class PostsController < ApplicationController

  def create
    @topic = Topic.find(params[:topic_id])
    @topic.new_post(Post.new(:nickname => current_user.nickname, :content => params[:post][:content]))
    @topic.save
    respond_to do |format|
      format.html { redirect_to topic_path(@topic.permalink) }
      format.mobile { redirect_to topic_path(@topic.permalink) }
      format.js
    end
  end

end
