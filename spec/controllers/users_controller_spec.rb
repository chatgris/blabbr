require 'spec_helper'

describe UsersController do

  describe 'current_user == user' do

    before :each do
      @current_user = Fabricate(:creator)
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
      get :show, :id => @current_user.slug
      response.should be_success
    end

    it 'should see edit' do
      get :edit
      response.should be_success
    end

    it 'should update user if current_user is user' do
      put :update, :user => {:email => 'new@email.com', :avatar => File.open(Rails.root.join("image.jpg")) }, :id => @current_user.id
      response.should redirect_to 'http://test.host/users/creator'
      @current_user.reload.email.should == 'new@email.com'
      @current_user.reload.avatar.url.should == '/uploads/avatars/creator.jpg'
    end

    it 'should update time_zone if current_user is user' do
      put :update, :user => {:email => 'new@email.com', :time_zone => 'Paris' }, :id => @current_user.id
      response.should redirect_to 'http://test.host/users/creator'
      @current_user.reload.email.should == 'new@email.com'
      @current_user.reload.time_zone.should == 'Paris'
    end

  end

  describe 'user != current_user' do

    before :each do
      @current_user = Fabricate(:creator)
      @user = Fabricate(:user)
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
      put :update, :user => {:email => 'new@email.com'}, :id => @user.id
      response.should redirect_to 'http://test.host/users/creator'
      @user.reload.email.should_not == 'new@email.com'
    end

  end

  # TODO
  describe 'create a user with an avatar' do
    it 'should have an avatar' do
      post :create, :user => {:email => 'new@email.com', :nickname => 'creator', :locale => 'fr', :password => 'password', :password_confirmation => 'password', :avatar => File.open(Rails.root.join("image.jpg")) }
      User.first.email.should == 'new@email.com'
      User.first.avatar.url.should == '/uploads/avatars/creator.jpg'
    end
  end

end
