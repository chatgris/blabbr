# encoding: utf-8
require 'spec_helper'

describe LinkHelper do
  before :each do
    @user = Factory.create(:creator)
    @topic = Factory.create(:topic)
    helper.stub!(:logged_in?).and_return(true)
    helper.stub!(:current_user).and_return(@user)
  end

  it "displays a 80px width avatar link to the user page" do
    @user.avatar = File.open(Rails.root.join("image.jpg"))
    @user.save
    helper.link_to_avatar(@user.slug).should == "<a href=\"/users/creator\"><img alt=\"Creator\" src=\"/uploads/avatars/creator.png\" /></a>"
  end

  it "displays a 25px width avatar link to the user page" do
    @user.avatar = File.open(Rails.root.join("image.jpg"))
    @user.save
    helper.link_to_avatar_thumb(@user.slug).should == "<a href=\"/users/creator\"><img alt=\"Thumb_creator\" src=\"/uploads/avatars/thumb_creator.png\" /></a>"
  end

  it "display a link when there's less posts than PER_PAGE" do
    @topic.posts_count = PER_PAGE - 1
    helper.link_to_unread(@topic).should == "<a href=\"/topics/one-topic/page/1#new_post\">0</a>"
  end

  it "display a link when there's PER_PAGE posts" do
    @topic.posts_count = PER_PAGE
    helper.link_to_unread(@topic).should == "<a href=\"/topics/one-topic/page/1#new_post\">0</a>"
  end

  it "display a link when there's more posts than PER_PAGE" do
    @topic.posts_count = PER_PAGE + 1
    helper.link_to_unread(@topic).should == "<a href=\"/topics/one-topic/page/2#new_post\">0</a>"
  end

  it "display a link when there's more unread posts" do
    @topic.posts_count = PER_PAGE
    @topic.members[0].unread = 1
    @topic.members[0].post_id = 1384681
    helper.link_to_unread(@topic).should == "<a href=\"/topics/one-topic/page/1#1384681\" class=\"new\">1</a>"
  end

end
