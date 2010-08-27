class SmiliesController < ApplicationController
  before_filter :authorize
  before_filter :get_current_smiley_for_creator, :only => [:edit, :update, :destroy]

  def index
    @smilies = Smiley.all
  end

  def edit
  end

  def new
    @smiley = Smiley.new
  end

  def create
    params[:smiley][:added_by] = current_user.nickname
    @smiley = Smiley.new(params[:smiley])
    if @smiley.save
      redirect_to root_path, :notice => t('smilies.created')
    else
      render :action => 'new'
    end
  end

  def update
    if @smiley.update_attributes(params[:smiley])
      redirect_to :back, :notice => t('smilies.updated')
    else
      render :edit
    end
  end

  def destroy
    unless @smiley.nil?
      @smiley.destroy
      redirect_to topics_url, :notice => t('smilies.destroy.success')
    else
      redirect_to topics_url, :alert => t('smilies.not_auth')
    end
  end

  protected

  def get_current_smiley_for_creator
    @smiley = Smiley.criteria.id(params[:id]).by_nickname(current_user.nickname).first
    unless @smiley
      redirect_to :back, :alert => t('smilies.not_auth')
    end
  end

end
