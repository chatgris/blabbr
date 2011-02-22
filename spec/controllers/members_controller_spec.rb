require 'spec_helper'

describe MembersController do
  describe 'with creator as current_user' do

    before :each do
      @current_user = Factory.create(:creator)
      @topic = Factory.create(:topic)
      @member = Factory.create(:user)
      @topic.new_member(@member.nickname)
      controller.stub!(:logged_in?).and_return(true)
      controller.stub!(:current_user).and_return(@current_user)
    end

    it "it should not add a member if he doesn't exist" do
      post :create, :nickname => 'New member', :topic_id => @topic.id
      response.should redirect_to(topic_path(@topic.slug))
      flash[:alert].should == I18n.t('member.not_find')
    end

    it "it should add a member" do
      post :create, :nickname => @member.nickname, :topic_id => @topic.id
      response.should redirect_to topic_path(@topic.slug)
      flash[:notice].should == I18n.t('member.add_success')
    end

    it "should fail when removing a user who is not a member" do
      delete :destroy, :id => "New member", :topic_id => @topic.id
      response.should redirect_to topic_path(@topic.slug)
      flash[:alert].should == I18n.t('member.not_find')
    end

    it "should remove a user from members" do
      delete :destroy, :id => @member.nickname, :topic_id => @topic.id
      response.should redirect_to topic_path(@topic.slug)
      flash[:notice].should == I18n.t('member.remove_success')
    end

  end

  describe 'with a logged user as current_user, not a member' do
    before :each do
      @current_user = Factory.create(:creator)
      @topic = Factory.create(:topic)
      @member = Factory.create(:user)
      @topic.new_member(@member.nickname)
      controller.stub!(:logged_in?).and_return(true)
      controller.stub!(:current_user).and_return(@member)
      request.env["HTTP_REFERER"] = "http://localhost:3000/topics/test"
    end

    it "it should not add a member" do
      post :create, :nickname => @member.nickname, :topic_id => @topic.id
      response.should redirect_to :back
      flash[:alert].should == I18n.t('topic.not_auth')
    end

    it "it should not delete a member" do
      post :create, :id => @member.nickname, :topic_id => @topic.id
      response.should redirect_to :back
      flash[:alert].should == I18n.t('topic.not_auth')
    end

  end
end
