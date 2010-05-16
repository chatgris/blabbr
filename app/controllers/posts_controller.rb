class PostsController < ApplicationController

  before_filter :authorize

  def create
    @topic = Topic.find(params[:topic_id])
    @topic.new_post(Topic.new(:nickname => current_user.nickname, :content => params[:post][:content]))
    @topic.save
    respond_to do |format|
      format.html { redirect_to topic_path(@topic.permalink) }
      format.mobile { redirect_to topic_path(@topic.permalink) }
      format.js
    end
  end

end
