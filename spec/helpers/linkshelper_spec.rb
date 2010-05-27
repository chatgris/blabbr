require 'spec_helper'

describe LinkHelper do
  before :all do
    @user = Factory.create(:chatgris)
    @topic = Factory.build(:topic)
  end

  it "displays a 80px width gravatar link to the user page" do
    helper.link_to_avatar(@user).should == "<a href=\"/users/chatgris\"><img alt=\"4f64c9f81bb0d4ee969aaf7b4a5a6f40\" src=\"http://www.gravatar.com/avatar/4f64c9f81bb0d4ee969aaf7b4a5a6f40.jpg?size=80\" /></a>"
  end

  it "displays a 25px width gravatar link to the user page" do
    helper.link_to_avatar_thumb(@user).should == "<a href=\"/users/chatgris\"><img alt=\"4f64c9f81bb0d4ee969aaf7b4a5a6f40\" src=\"http://www.gravatar.com/avatar/4f64c9f81bb0d4ee969aaf7b4a5a6f40.jpg?size=25\" /></a>"
  end

  it "displays a 80px width avatar link to the user page" do
    @user.avatar = File.open(Rails.root.join("image.jpg"))
    @user.save
    helper.link_to_avatar(@user).should == "<a href=\"/users/chatgris\"><img alt=\"Chatgris\" src=\"/uploads/avatars/chatgris.jpg\" /></a>"
  end

  it "displays a 25px width avatar link to the user page" do
    helper.link_to_avatar_thumb(@user).should == "<a href=\"/users/chatgris\"><img alt=\"Thumb_chatgris\" src=\"/uploads/avatars/thumb_chatgris.jpg\" /></a>"
  end

end
