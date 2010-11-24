class UsersController < ApplicationController
  before_filter :edit_user, :only => ['edit', 'update']
  after_filter :reset_cache, :only => ['update']

  def index
    @users = User.all.paginate :page => params[:page] || nil, :per_page => 10
  end

  def autocomplete
    @users = User.where(:nickname => /#{params[:q]}/).all
  end

  def edit
  end

  def new
    redirect_to :back
  end

  def show
    @user = User.by_slug(params[:id]).first
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:current_user] = @user.id
      flash[:notice] =  "User was successfully created"
      redirect_to root_url
    else
      flash[:error] = "User failed to be created"
      render :new
    end
  end

  def update
    if @user.update_attributes(params[:user])
        redirect_to :back
    else
      render :edit
    end
  end

  protected

  def edit_user
    @user = current_user
  end

  def reset_cache
    expire_fragment "topics-#{@user.id}"
  end

end
