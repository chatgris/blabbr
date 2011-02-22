require 'spec_helper'

describe TopicsController do

  describe 'with creator as current_user' do

    before :each do
      @current_user = Factory.create(:creator)
      @topic = Factory.create(:topic)
      controller.stub!(:logged_in?).and_return(true)
      controller.stub!(:current_user).and_return(@current_user)
      request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
    end

    it 'should show an empty topics index' do
      get :index
      response.should be_success
    end

    it 'get new should be success' do
      get :new
      response.should be_success
    end

    it 'should see show' do
      get :show, :id => @topic.slug
      response.should be_success
    end

    it 'should see edit' do
      get :edit, :id => @topic.id
      response.should be_success
    end

    it 'should create a new topic, and redirect to it' do
      lambda do
        post :create, :topic => { :title => 'New topic', :post => "post content" }
      end.should change(Topic, :count)
      response.should redirect_to(topic_path(Topic.last.slug))
      flash[:notice].should == I18n.t('topics.create.success')
    end

    it 'should not create a topic with wrong params' do
      lambda do
        post :create, :topic => { :title => '' }
      end.should_not change(Topic, :count)
      response.should be_success
    end

    it 'should update project name if user is admin on this project' do
      put :update, :topic => {:title => 'New title'}, :id => @topic.id
      response.should redirect_to(topic_path("one-topic"))
      @topic.reload.title.should == 'New title'
    end

    it 'should delete the topic' do
      lambda do
        delete :destroy, :id => @topic.id
      end.should change(Topic, :count).by(-1)
      Topic.criteria.id(@topic.id).first.should be_nil
      response.should redirect_to :back
    end

  end

  describe 'with a logged user as current_user, not a member' do

    before :each do
      @creator = Factory.create(:creator)
      @topic = Factory.create(:topic)
      @current_user = Factory.create(:user)
      controller.stub!(:logged_in?).and_return(true)
      controller.stub!(:current_user).and_return(@current_user)
      request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
    end

    it 'should not see topic' do
      get :show, :id => @topic.slug
      response.should redirect_to :back
      flash[:alert].should == I18n.t('topic.not_auth')
    end

    it 'should not see edit' do
      get :edit, :id => @topic.id
      response.should redirect_to :back
      flash[:alert].should == I18n.t('topic.not_auth')
    end

    it 'get new should be success' do
      get :new
      response.should be_success
    end

    it 'should not delete the topic' do
      lambda do
        delete :destroy, :id => @topic.id
      end.should_not change(Topic, :count).by(-1)
      response.should redirect_to :back
      flash[:alert].should == I18n.t('topic.not_auth')
    end

  end

  describe 'with a logged user as current_user, current_user is a member' do

    before :each do
      @creator = Factory.create(:creator)
      @topic = Factory.create(:topic)
      @current_user = Factory.create(:user)
      @topic.new_member(@current_user.nickname)
      controller.stub!(:logged_in?).and_return(true)
      controller.stub!(:current_user).and_return(@current_user)
      request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
    end

    it 'should see topic' do
      get :show, :id => @topic.slug
      response.should be_success
    end

    it 'should not see edit' do
      get :edit, :id => @topic.id
      response.should redirect_to :back
      flash[:alert].should == I18n.t('topic.not_auth')
    end

    it 'should not delete the topic' do
      lambda do
        delete :destroy, :id => @topic.id
      end.should_not change(Topic, :count).by(-1)
      response.should redirect_to :back
      flash[:alert].should == I18n.t('topic.not_auth')
    end

  end

end
