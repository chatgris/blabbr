require 'spec_helper'

describe PostsController do

  context "is a member" do
    before :each do
      @current_user = Fabricate(:creator)
      @topic = Fabricate(:topic)
      @post = Fabricate.build(:post)
      controller.stub!(:logged_in?).and_return(true)
      controller.stub!(:current_user).and_return(@current_user)
      request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
    end

    it "should add a post" do
      post :create, :post => {"body" => @post.body}, :topic_id => @topic.slug
      response.should redirect_to "/topics/#{@topic.slug}/page/1##{Post.last.id.to_s}"
      flash[:notice].should == I18n.t('posts.create.success')
    end

    it "should not add a post if params are wrong" do
      post :create, :post => {"body" => ''}, :topic_id => @topic.slug
      response.should render_template("new")
      flash[:alert].should == I18n.t('posts.create.error')
    end

    it 'should see edit' do
      get :edit, :id => @post.id, :topic_id => @topic.slug
      response.should be_success
    end

    it 'should update message' do
      put :update, :id => @topic.posts.first.id, :topic_id => @topic.slug,  :post => {"body" => 'New message'}
      response.should redirect_to :back
      @topic.reload.posts.first.body.should == 'New message'
    end

  end

  describe 'deleting a post' do

    before :each do
      @current_user = Fabricate(:creator)
      @topic = Fabricate(:topic, :user => @current_user)
      request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
      @post = Post.first
    end

    context 'when current_user == post.user' do

      before do
        controller.stub!(:logged_in?).and_return(true)
        controller.stub!(:current_user).and_return(@current_user)
      end

      it 'should delete a post' do
        delete :destroy, :id => @post.id, :topic_id => @topic.slug
        response.should redirect_to :back
        flash[:notice].should == I18n.t('posts.delete_success')
      end

    end

    context 'when current_user != post.user' do
      before do
        @user = Fabricate(:user)
        @topic.new_member(@user.nickname)
        controller.stub!(:logged_in?).and_return(true)
        controller.stub!(:current_user).and_return(@user)
      end

      it "shouldn't delete a post" do
        delete :destroy, :id => @post.id, :topic_id => @topic.slug
        response.should redirect_to :back
        flash[:alert].should == I18n.t('posts.delete_unsuccess')
      end

    end
  end

  context "is a registred user, but not a member" do
    before :each do
      @creator = Fabricate(:creator)
      @topic = Fabricate(:topic)
      @current_user = Fabricate(:user)
      controller.stub!(:logged_in?).and_return(true)
      controller.stub!(:current_user).and_return(@current_user)
      request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
    end

    it "should not add a post" do
      @post = Fabricate.build(:post)
      post :create, :post => @post, :topic_id => @topic.slug
      response.should redirect_to :back
      flash[:alert].should == I18n.t('topic.not_auth')
    end
  end

end
