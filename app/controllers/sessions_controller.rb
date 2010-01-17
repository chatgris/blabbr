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
  
  def open_id_authentication(openid_url)
    authenticate_with_open_id(openid_url, :required => [:nickname, :email]) do |result, identity_url, registration|
      if result.successful?
        @user = User.find_or_initialize_by_identity_url(identity_url)
        if @user.new_record?
          @user.nickname = registration['nickname']
          @user.email = registration['email']
          @user.save(false)
        end
        successful_login
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
    flash[:notice] = "Logged in successfully"
  end
end

