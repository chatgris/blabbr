class UsersController < ApplicationController
  before_filter :authorize, :except => ['create']

  def index
    @users = User.all.paginate :page => params[:page] || nil, :per_page => 10
  end

  def edit
    @user = current_user
  end

  def new
    redirect_to :back
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
    @user = current_user
    if @user.update_attributes(params[:user])
        redirect_to :back
    else
      render :edit
    end
  end

end
