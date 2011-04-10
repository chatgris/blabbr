# encoding: utf-8
class UsersController < ApplicationController
  before_filter :edit_user, :only => ['edit', 'update']
  after_filter :reset_cache, :only => ['update']
  respond_to :html, :js

  def autocomplete
    @users = User.where(:nickname => /#{params[:q]}/).all
  end

  def edit
  end

  def show
    @user = User.by_slug(params[:id]).first
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:current_user] = @user.id
      flash[:notice] =  t('users.create.success')
    else
      flash[:alert] = t('users.create.fail')
    end
    respond_with(@user, :location => root_path)
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = t('users.update.success')
    else
      flash[:alert] = t('users.update.fail')
    end
    respond_with(@user, :location => user_path(@user.slug))
  end

  protected

  def edit_user
    @user = current_user
  end

  def reset_cache
    expire_fragment "topics-#{@user.id}"
  end

end
