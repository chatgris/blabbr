require 'spec_helper'

describe PostsController do

  context "is a member" do
    before :each do
      @current_user = Factory.create(:creator)
      @topic = Factory.create(:topic)
      @post = Factory.build(:post)
      controller.stub!(:logged_in?).and_return(true)
      controller.stub!(:current_user).and_return(@current_user)
    end

    it "should add a post" do
      request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
      post :create, :post => @post, :topic_id => @topic.permalink, :body => @post.body
      response.should redirect_to :back
      flash[:notice].should == I18n.t('post.success')
    end

    it "should not add a post if params are wrong" do
      request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
      @post = Factory.build(:post, :body => '')
      post :create, :post => @post, :topic_id => @topic.permalink
      response.should redirect_to :back
      flash[:error].should == I18n.t('post.error')
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
      flash[:error].should == I18n.t('topic.not_auth')
    end
  end

end
