class SmiliesController < ApplicationController
  before_filter :get_current_smiley_for_creator, :only => [:update, :destroy]
  respond_to :json

  def index
    @smilies = Smiley.all
    respond_with @smilies
  end

  def create
    @smiley = Smiley.new(params[:smiley])
    @smiley.added_by = current_user.nickname
    if @smiley.save
      flash[:notice] = t('smilies.create.success')
    else
      flash[:alert] = t('smilies.create.fail')
    end
    respond_with(@smiley, :location => root_path)
  end

  def update
    if @smiley.update_attributes(params[:smiley])
      flash[:notice] = t('smilies.update.success')
    else
      flash[:alert] = t('smilies.update.fail')
    end
    respond_with(@smiley, :location => root_path)
  end

  def destroy
    if @smiley.destroy
      flash[:notice] = t('smilies.destroy.success')
    else
      flash[:alert] = t('smilies.destroy.fail')
    end
    respond_with(@smiley, :location => root_path)
  end

  protected

  def get_current_smiley_for_creator
    @smiley = Smiley.criteria.for_ids(params[:id]).by_nickname(current_user.nickname).first
    unless @smiley
      redirect_to :back, :alert => t('smilies.not_auth')
    end
  end

end
