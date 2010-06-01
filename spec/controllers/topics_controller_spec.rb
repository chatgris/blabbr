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
    it 'should not can create project' do
      post :create, :topic => { :name => 'My big project' }
      response.should redirect_to login_path
    end
    it 'should not can edit a project' do
      get :edit, :id => Factory.build(:topic).id.to_s
      response.should redirect_to login_path
    end
  end

  describe 'with a user logged' do

    before :all do
      @current_user = Factory.build(:creator)
    end

    before :each do
      controller.stub!(:logged_in?).and_return(true)
      controller.stub!(:current_user).and_return(@current_user)
    end

    it 'should show an empty topics index' do
      get :index
      response.should be_success
    end

    describe "GET index" do
      it "assigns all topics as @topics"
    end

    describe "GET show" do
      it "assigns the requested topic as @topic"
    end

    describe "GET new" do
      it "assigns a new topic as @topic"
    end

    describe "GET edit" do
      it "assigns the requested topic as @topic"
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
end
