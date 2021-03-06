# encoding: utf-8
class TopicsController < ApplicationController
  before_filter :get_topic, :only => [:show, :update, :destroy, :add_member, :rm_member]
  after_filter :reset_unread_posts, :only => [:show]
  respond_to :json
  authorize_resource
  caches_action :show, :if => Proc.new { |c| c.request.format.json? }

  def index
    @topics = Topic.by_subscribed_topic(current_user.nickname).desc(:posted_at).page current_page
    respond_to do |format|
      format.json {render :json => {:topics => @topics,
                                    :current_page => current_page,
                                    :per_page => @topics.limit_value,
                                    :total_entries => @topics.total_count}}
    end
  end

  def show
    @posts = @topic.posts.asc(:created_at).page current_page
    respond_to do |format|
      format.json { render :json => {:topic => @topic,
                                     :posts => @posts,
                                     :current_page => current_page,
                                     :per_page => @posts.limit_value,
                                     :total_entries => @posts.total_count}}
    end
  end

  def create
    @topic = Topic.new(params[:topic])
    @topic.user = current_user

    if @topic.save
      flash[:notice] = t('topics.create.success')
      @posts = @topic.posts.page
      respond_to do |format|
        format.json { render :json => {:topic => @topic,
                                       :posts => @posts,
                                       :current_page => current_page,
                                       :per_page => @posts.limit_value,
                                       :total_entries => @posts.total_count},
                              :status => 201}
      end
    else
      flash[:alert] = t('topics.create.fail')
      respond_to do |format|
        format.json { render :json => @topic.errors,
                             :status => 422}
      end
    end
    # TODO: custom responder
  end

  def update
    @topic.update_members params[:topic].delete('members_list')
    if @topic.update_attributes(params[:topic])
      flash[:notice] = t('topics.update.success')
      respond_to do |format|
        format.json {render :json => @topic, :status => 200}
      end
    else
      flash[:alert] = t('topics.update.fail')
      respond_to do |format|
        format.json {render :json => @topic, :status => 200}
      end
    end
  end

  def destroy
    if @topic.delete!
      flash[:notice] = t('topics.delete.success')
    else
      flash[:alert] = t('topics.delete.fail')
    end
    respond_with(@topic, :location => topics_path)
  end

  protected

  def users_list
    @users = User.criteria.excludes(:nickname => current_user.nickname).order_by([[:created_at, :desc]]).flatten
  end

  def reset_unread_posts
    @topic.reset_unread(current_user.nickname) if @topic
  end

end
