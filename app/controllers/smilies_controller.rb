class SmiliesController < ApplicationController
  before_filter :authorize

  def index
    @smilies = Smiley.all
  end

  def edit
    @smiley = Smiley.criteria.id(params[:id]).first
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
    @smiley = Smiley.criteria.id(params[:id]).first
    if @smiley.update_attributes(params[:smiley])
      redirect_to :back
    else
      render :edit
    end
  end

end
