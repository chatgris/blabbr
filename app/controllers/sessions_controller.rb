class SessionsController < ApplicationController

  def new
  end

  def create
    open_id_authentication(params[:openid_url])
  end

  def destroy
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_to login_path
  end
  
  protected
  
  def open_id_authentication(identity_url)
    authenticate_with_open_id(identity_url, :required => [ :email, 'http://axschema.org/contact/email' ]) do |result, identity_url, registration|
      if result.successful?
        email = registration['email'] || registration['http://axschema.org/contact/email']
        @user = User.find_by_email(email)
        if @user.nil?
          @user = User.new(:email => email)
          render 'users/new'
        else
          successful_login
        end
      else
        failed_login result.message
      end
    end
  end
  
  def failed_login(message = "Authentication failed.")
    flash.now[:error] = message
    render :action => 'new'
  end
  
  def successful_login
    session[:current_user] = @user.id
    redirect_to root_path
    flash[:notice] = "Welcome back #{@user.nickname}." unless flash[:welcome]
  end
  
  def first_login
    session[:current_user] = @user.id
    redirect_to home_url
    flash[:welcome] = "Welcome on Blabber. If the nickname provide on this form is not the one you was expecting, now is the only chance you can change it."
  end
end

