require 'spec_helper'

describe UsersController do
  describe 'with an anonymous user' do
    it 'should not see index' do
      get :index
      response.should redirect_to new_user_session_path
    end

    it 'should not see show' do
      get :show, :id => Factory.build(:user).id.to_s
      response.should redirect_to new_user_session_path
    end

    it 'should not see new' do
      get :new
      response.should redirect_to new_user_session_path
    end

    it 'should not can edit a project' do
      get :edit, :id => Factory.build(:user).id.to_s
      response.should redirect_to new_user_session_path
    end

  end

  describe 'current_user == user' do

    before :each do
      @current_user = Factory.create(:creator)
      controller.stub!(:logged_in?).and_return(true)
      controller.stub!(:current_user).and_return(@current_user)
    end

    it 'should be able to see index' do
      get :index
      response.should be_success
    end

    it 'get new should be success' do
      request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
      get :new
      response.should redirect_to :back
    end

    it 'should see show' do
      get :show, :id => @current_user.permalink
      response.should be_success
    end

    it 'should see edit' do
      get :edit
      response.should be_success
    end

    it 'should update user if current_user is user' do
      request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
      put :update, :user => {:email => 'new@email.com'}, :id => @current_user.id
      response.should redirect_to :back
      @current_user.reload.email.should == 'new@email.com'
    end

  end

  describe 'user != current_user' do

    before :each do
      @current_user = Factory.create(:creator)
      @user = Factory.create(:user)
      controller.stub!(:logged_in?).and_return(true)
      controller.stub!(:current_user).and_return(@current_user)
    end

    it 'should be able to see index' do
      get :index
      response.should be_success
    end

    it 'get new should be success' do
      request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
      get :new
      response.should redirect_to :back
    end

    it 'should update user if current_user is user' do
      request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
      put :update, :user => {:email => 'new@email.com'}, :id => @user.id
      response.should redirect_to :back
      @user.reload.email.should_not == 'new@email.com'
    end

  end

end
