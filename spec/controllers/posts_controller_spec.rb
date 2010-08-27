require 'spec_helper'

describe PostsController do

  context "is a member" do
    before :each do
      @current_user = Factory.create(:creator)
      @topic = Factory.create(:topic)
      @post = Factory.build(:post)
      controller.stub!(:logged_in?).and_return(true)
      controller.stub!(:current_user).and_return(@current_user)
      request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
    end

    it "should add a post" do
      post :create, :post => {"body" => @post.body}, :topic_id => @topic.permalink
      response.should redirect_to :back
      flash[:notice].should == I18n.t('post.success')
    end

    it "should not add a post if params are wrong" do
      post :create, :post => {"body" => ''}, :topic_id => @topic.permalink
      response.should redirect_to :back
      flash[:alert].should == I18n.t('post.error')
    end

    it 'should see edit' do
      get :edit, :id => @post.id, :topic_id => @topic.permalink
      response.should be_success
    end

    it 'should update message' do
      put :update, :id => @topic.posts.first.id, :topic_id => @topic.permalink,  :post => {"body" => 'New message'}
      response.should redirect_to :back
      @topic.reload.posts.first.body.should == 'New message'
    end

  end

  describe 'deleting a post' do

    before :each do
      @current_user = Factory.create(:creator)
      @topic = Factory.create(:topic)
      request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
      @post = Post.first
    end

    context 'when current_user == post.user' do

      before do
        controller.stub!(:logged_in?).and_return(true)
        controller.stub!(:current_user).and_return(@current_user)
      end

      it 'should delete a post' do
        delete :destroy, :id => @post.id, :topic_id => @topic.permalink
        response.should redirect_to :back
        flash[:notice].should == I18n.t('posts.delete_success')
      end

    end

    context 'when current_user != post.user' do
      before do
        @user = Factory.create(:user)
        @topic.new_member(@user.nickname)
        controller.stub!(:logged_in?).and_return(true)
        controller.stub!(:current_user).and_return(@user)
      end

      it "shouldn't delete a post" do
        delete :destroy, :id => @post.id, :topic_id => @topic.permalink
        response.should redirect_to :back
        flash[:alert].should == I18n.t('posts.delete_unsuccess')
      end

    end
  end

  context "is a registred user, but not a member" do
    before :each do
      @creator = Factory.create(:creator)
      @topic = Factory.create(:topic)
      @current_user = Factory.create(:user)
      controller.stub!(:logged_in?).and_return(true)
      controller.stub!(:current_user).and_return(@current_user)
      request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
    end

    it "should not add a post" do
      @post = Factory.build(:post)
      post :create, :post => @post, :topic_id => @topic.permalink
      response.should redirect_to :back
      flash[:alert].should == I18n.t('topic.not_auth')
    end
  end

end
