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

  def show
    @smiley = Smiley.criteria.id(params[:id]).first
  end

  def create
    params[:smiley][:added_by] = current_user.nickname
    @smiley = Smiley.new(params[:smiley])
    if @smiley.save
      flash[:notice] = "Smiley ajouté"
      redirect_to root_path
    else
      render :action => 'new'
    end
  end

  def update
    if @smiley.update_attributes(params[:smiley])
      redirect_to :back
    else
      render :edit
    end
  end

  def destroy
    unless @smiley.nil?
      @smiley.destroy
      flash[:notice] = t('smilies.destroy.success')
    else
      flash[:error] = t('smilies.not_auth')
    end
    redirect_to topics_url
  end

  protected

  def get_current_smiley_for_creator
    @smiley = Smiley.criteria.id(params[:id]).by_nickname(current_user.nickname).first
    unless @smiley
      flash[:error] = t('smilies.not_auth')
      redirect_to :back
    end
  end

end
