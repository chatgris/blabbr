class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def edit
    @user = current_user
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] =  "User was successfully created"
      redirect_to edit_user_url(@user)
    else
      flash[:error] = "User failed to be created"
      render :new
    end
  end

  def update
    @user = User.find(params[:id])
    return return_404 unless @user
    if @user.update_attributes(params[:user])
       redirect_to projects_url
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    return return_404 unless @user
    if @user.destroy
      redirect_to users_url
    else
      raise InternalServerError
    end
  end

end

