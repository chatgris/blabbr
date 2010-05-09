class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def edit
    @user = User.by_permalink(params[:id]).first
  end

  def show
    @user = User.by_permalink(params[:id]).first
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
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
        redirect_to :back
    else
      render :edit
    end
  end

end
