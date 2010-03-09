class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def edit
    @user = User.find(@current_user.id)
  end
  
  def show
    @user = User.first(:id => params[:id])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] =  "User was successfully created"
      redirect_to home_url
    else
      flash[:error] = "User failed to be created"
      render :new
    end
  end

  def update
    if params[:id] == current_user.id.to_s
        @user = User.find(params[:id])
      return return_404 unless @user
      if @user.update_attributes(params[:user])
         redirect_to home_url
      else
        render :edit
      end
    else
      flash[:error] = "User failed to be updated"
      redirect_to home_url
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

