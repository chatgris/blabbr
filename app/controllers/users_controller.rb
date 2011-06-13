# encoding: utf-8
class UsersController < ApplicationController
  after_filter :reset_cache, :only => ['update']
  respond_to :json

  def autocomplete
    @users = User.only(:nickname).where(:nickname => /#{params[:q]}/i)
    respond_with @users.map(&:nickname)
  end

  def show
    respond_with(@user = User.by_slug(params[:id]).first)
  end

  def current
    respond_to do |format|
      format.json {render :json => current_user.as_json({:only => [:nickname, :posts_count, :time_zone, :audio, :email, :slug]}), :status => 200}
    end
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
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = t('users.update.success')
      respond_to do |format|
        format.json {render :json => @user.as_json({:only => [:nickname, :posts_count, :time_zone, :audio, :email, :slug]}), :status => 200}
      end
    else
      flash[:alert] = t('users.update.fail')
      respond_to do |format|
        format.json {render :json => @user.errors, :status => 422}
      end
    end
  end

  protected

  def reset_cache
    expire_fragment "topics-#{@user.id}"
  end

end
