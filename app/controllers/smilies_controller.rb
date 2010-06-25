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

  def update
    @smiley = Smiley.criteria.id(params[:id]).first
    if @smiley.update_attributes(params[:smiley])
      redirect_to :back
    else
      render :edit
    end
  end

end
