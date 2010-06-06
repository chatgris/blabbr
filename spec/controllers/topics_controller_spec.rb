require 'spec_helper'

describe TopicsController do

  describe 'with an anonymous user' do
    it 'should not see index' do
      get :index
      response.should redirect_to login_path
    end

    it 'should not see show' do
      get :show, :id => Factory.build(:topic).id.to_s
      response.should redirect_to login_path
    end

    it 'should not see new' do
      get :new
      response.should redirect_to login_path
    end

    it 'should not can create project' do
      post :create, :topic => { :name => 'My big project' }
      response.should redirect_to login_path
    end

    it 'should not can edit a project' do
      get :edit, :id => Factory.build(:topic).id.to_s
      response.should redirect_to login_path
    end
  end

  describe 'with creator as current_user' do

    before :all do
      @current_user = Factory.create(:creator)
      @topic = Factory.create(:topic)
    end

    before :each do
      controller.stub!(:logged_in?).and_return(true)
      controller.stub!(:current_user).and_return(@current_user)
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
      get :show, :id => @topic.permalink
      response.should be_success
    end

    it 'should see edit' do
      get :edit, :id => @topic.id
      response.should be_success
    end

    it 'should create a new topic, and redirect to it' do
      lambda do
        post :create, :topic => { :title => 'New topic' }
      end.should change(Topic, :count)
      response.should redirect_to(topic_path(Topic.last.permalink))
      flash[:notice].should == 'Successfully created topic.'
    end

    it 'should not create a topic with wrong params' do
      lambda do
        post :create, :topic => { :title => '' }
      end.should_not change(Topic, :count)
      response.should be_success
    end

    it 'should update project name if user is admin on this project' do
      put :update, :topic => {:title => 'New title'}, :id => @topic.id
      response.should redirect_to(topic_path("new-title"))
      @topic.reload.title.should == 'New title'
    end

    it "it should not a member if he doesn't exist" do
      put :add_member, :nickname => 'New member', :id => @topic.id
      response.should redirect_to(topic_path(@topic.permalink))
      flash[:error].should == I18n.t('member.not_find')
    end

    it "it should add a member" do
      member = Factory.create(:user)
      put :add_member, :nickname => member.nickname, :id => @topic.id
      response.should redirect_to topic_path(@topic.permalink)
      flash[:notice].should == I18n.t('member.add_success')
    end

    it "should fail when removing a user who is not a member" do
      delete :remove_member, :nickname => "New member", :id => @topic.id
      response.should redirect_to topic_path(@topic.permalink)
      flash[:error].should == I18n.t('member.not_find')
    end

    it "should remove a user from members" do
      member = Factory.build(:user)
      delete :remove_member, :nickname => member.nickname, :id => @topic.id
      response.should redirect_to topic_path(@topic.permalink)
      flash[:notice].should == I18n.t('member.remove_success')
    end

    it "should add a post" do
      request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
      post = Factory.build(:post)
      put :add_post, :post => post, :id => @topic.permalink
      response.should redirect_to :back
      flash[:notice].should == I18n.t('post.success')
    end

    it "should not add a post if params are wrong" do
      request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
      post = Factory.build(:post, :body => '')
      put :add_post, :post => post, :id => @topic.permalink
      response.should redirect_to :back
      flash[:error].should == I18n.t('post.error')
    end

    it 'should delete the topic' do
      lambda do
        delete :destroy, :id => @topic.id
      end.should change(Topic, :count).by(-1)
      Topic.criteria.id(@topic.id).first.should be_nil
      response.should redirect_to topics_path
    end

  end

  describe 'with a logged user as current_user, not a member' do

    before :all do
      @creator = Factory.create(:creator)
      @topic = Factory.create(:topic)
      @current_user = Factory.create(:user)
    end

    before :each do
      controller.stub!(:logged_in?).and_return(true)
      controller.stub!(:current_user).and_return(@current_user)
      request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
    end

    it 'should not see topic' do
      get :show, :id => @topic.permalink
      response.should redirect_to :back
      flash[:error].should == I18n.t('topic.not_auth')
    end

    it 'should not see edit' do
      get :edit, :id => @topic.permalink
      response.should redirect_to :back
      flash[:error].should == I18n.t('topic.not_auth')
    end

    it 'get new should be success' do
      get :new
      response.should be_success
    end

    it "should not add a post" do
      post = Factory.build(:post)
      put :add_post, :post => post, :id => @topic.permalink
      response.should redirect_to :back
      flash[:error].should == I18n.t('topic.not_auth')
    end

    it 'should not delete the topic' do
      lambda do
        delete :destroy, :id => @topic.id
      end.should_not change(Topic, :count).by(-1)
      response.should redirect_to :back
      flash[:error].should == I18n.t('topic.not_auth')
    end

  end

  describe 'with a logged user as current_user, current_user is a member' do

    before :all do
      @creator = Factory.create(:creator)
      @topic = Factory.create(:topic)
      @current_user = Factory.create(:user)
      @topic.new_member(@current_user.nickname)
    end

    before :each do
      controller.stub!(:logged_in?).and_return(true)
      controller.stub!(:current_user).and_return(@current_user)
      request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
    end

    it 'should see topic' do
      get :show, :id => @topic.permalink
      response.should be_success
    end

    it 'should not see edit' do
      get :edit, :id => @topic.permalink
      response.should redirect_to :back
      flash[:error].should == I18n.t('topic.not_auth')
    end

    it "should add a post" do
      post = Factory.build(:post)
      put :add_post, :post => post, :id => @topic.permalink
      response.should redirect_to :back
      flash[:notice] = t('post.success')
    end

    it "should not add a member" do
      member = Factory.create(:invited)
      put :add_member, :nickname => member.nickname, :id => @topic.permalink
      response.should redirect_to :back
      flash[:error] = t('topic.not_auth')
    end

    it 'should not delete the topic' do
      lambda do
        delete :destroy, :id => @topic.id
      end.should_not change(Topic, :count).by(-1)
      response.should redirect_to :back
      flash[:error].should == I18n.t('topic.not_auth')
    end

  end

end
