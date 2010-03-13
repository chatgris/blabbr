class UsersController < ApplicationController

  before_filter :redirect_if_no_logged, :except => [:new, :create]

  def new
    @user = User.new
  end

  def edit
    @user = @current_user
  end
  
  def show
    @user = User.first(:id => params[:id])
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

