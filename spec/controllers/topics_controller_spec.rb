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
      get :edit, :id => @topic.permalink
      response.should be_success
    end

    describe "POST create" do

      describe "with valid params" do

        it "redirects to the created topic"
      end

      describe "with invalid params" do

        it "re-renders the 'new' template"
      end

    end

    describe "PUT update" do

      describe "with valid params" do
        it "updates the requested topic"

        it "redirects to the topic"
      end

      describe "with invalid params" do
        it "re-renders the 'edit' template"
      end

    end

    describe "DELETE destroy" do

      it "destroys the requested topic"

      it "redirects to the topics list"
    end
  end

  describe 'with creator as current_user' do

    before :all do
      @creator = Factory.create(:creator)
      @topic = Factory.create(:topic)
      @current_user = Factory.create(:user)
    end

    before :each do
      controller.stub!(:logged_in?).and_return(true)
      controller.stub!(:current_user).and_return(@current_user)
    end

    it 'should see show' do
      get :show, :id => @topic.permalink
      response.should redirect_to topics_path
    end

    it 'should see edit' do
      request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
      get :edit, :id => @topic.permalink
      response.should redirect_to :back
    end

  end
end
