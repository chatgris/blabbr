require 'spec_helper'

describe LinkHelper do
  before :all do
    @user = Factory.create(:creator)
    @topic = Factory.build(:topic)
  end

  it "displays a 80px width gravatar link to the user page" do
    helper.link_to_avatar(@user).should == "<a href=\"/users/creator\"><img alt=\"4f64c9f81bb0d4ee969aaf7b4a5a6f40\" src=\"http://www.gravatar.com/avatar/4f64c9f81bb0d4ee969aaf7b4a5a6f40.jpg?size=80\" /></a>"
  end

  it "displays a 25px width gravatar link to the user page" do
    helper.link_to_avatar_thumb(@user).should == "<a href=\"/users/creator\"><img alt=\"4f64c9f81bb0d4ee969aaf7b4a5a6f40\" src=\"http://www.gravatar.com/avatar/4f64c9f81bb0d4ee969aaf7b4a5a6f40.jpg?size=25\" /></a>"
  end

  it "displays a 80px width avatar link to the user page" do
    @user.avatar = File.open(Rails.root.join("image.jpg"))
    @user.save
    helper.link_to_avatar(@user).should == "<a href=\"/users/creator\"><img alt=\"Creator\" src=\"/uploads/avatars/creator.jpg\" /></a>"
  end

  it "displays a 25px width avatar link to the user page" do
    helper.link_to_avatar_thumb(@user).should == "<a href=\"/users/creator\"><img alt=\"Thumb_creator\" src=\"/uploads/avatars/thumb_creator.jpg\" /></a>"
  end

end
