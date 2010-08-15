class SessionsController < ApplicationController

  def new
  end

  def create
    if params[:openid_url].nil?
      open_id_authentication(params[:openid_url])
    elsif params[:openid_url].empty?
      failed_login "You need to privide a openid compliant url"
    else
      open_id_authentication(params[:openid_url])
    end
  end

  def destroy
    cookies.delete :auth_token
    reset_session
    redirect_to login_path
  end

  protected

  def open_id_authentication(openid_url)
    authenticate_with_open_id(openid_url, :required => [:nickname, :email, 'http://schema.openid.net/contact/email' ]) do |result, identity_url, registration|
      if result.successful?
        @user = User.by_identity_url(identity_url).first
        if @user.nil?
          create_openid_user(registration, identity_url)
        else
          successful_login
        end
      else
        failed_login result.message
      end
    end
  end

  def create_openid_user(registration, identity_url)
    @user = User.new(:nickname => registration["nickname"], :email => registration["email"], :identity_url=> identity_url)
    render 'users/new'
  end

  def failed_login(message = "Authentication failed.")
    flash.now[:error] = message
    render :action => 'new'
  end

  def successful_login
    set_current_user
    redirect_to root_path
    flash[:notice] = "Welcome back #{@user.nickname}." unless flash[:welcome]
  end

  def first_login
    set_current_user
    redirect_to home_url
    flash[:welcome] = "Welcome on Blabber. If the nickname provide on this form is not the one you was expecting, now is the only chance you can change it."
  end

  def set_current_user
    session[:current_user] = @user.id
  end
end
