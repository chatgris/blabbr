# encoding: utf-8
require 'spec_helper'


def current_user(stubs = {})
  @current_user ||= Factory.create(:creator)
end

describe TopicsHelper do
  describe "textilize" do

    before do
      @smiley = Factory.build(:smiley)
      @smiley.image = File.open(Rails.root.join("image.jpg"))
      @smiley.save
    end

    it "should do basic textile" do
      helper.textilize("hello *world*").should == "<p>hello <strong>world</strong></p>"
    end

    it "should allow img tag" do
      helper.textilize("!http://www.example.com/image.jpg(Alt)!").should == "<p><img src=\"http://www.example.com/image.jpg\" title=\"Alt\" alt=\"Alt\" /></p>"
    end

    it "should allow link on images" do
      helper.textilize("!http://www.example.com/image.jpg!:http://example.com/link").should == "<p><a href=\"http://example.com/link\"><img src=\"http://www.example.com/image.jpg\" alt=\"\" /></a></p>"
    end

    it "should allow link tag" do
      helper.textilize("\"link\":http://redcloth.org").should == "<p><a href=\"http://redcloth.org\">link</a></p>"
    end

    it "should escape javascript" do
      helper.textilize("<script type=\"text/javascript\">alert(\"test\");</script>").should == "<p>alert(&#8220;test&#8221;);</p>"
    end

    it "should allow smilies" do
      helper.textilize("Test de smiley :doc:").should == "<p>Test de smiley <img src=\"/uploads/smilies/doc.jpg?#{@smiley.updated_at.to_i.to_s}\" title=\"doc\" alt=\"doc\" /></p>"
    end
  end

  describe "ratio links" do

    before do
      @current_user = Factory.create(:creator)
      @topic = Factory.create(:topic)
      helper.stub!(:logged_in?).and_return(true)
      helper.stub!(:current_user).and_return(@current_user)
    end

    it "should display posts ratio" do
      helper.post_ratio(@topic).should == "1/1"
    end

    it "should display attachments ratio" do
      helper.attachments_ratio(@topic).should == "0/0"
    end
  end

  describe "topics various helpers" do

    before :each do
      @creator = Factory.create(:creator)
      @user = Factory.create(:user)
      @topic = Factory.create(:topic)
      @topic.add_member(@user.nickname)
    end

    it "should return a array of members without the creator" do
      helper.members_without_creator(@topic).map(&:nickname).should include(@user.nickname)
      helper.members_without_creator(@topic).map(&:nickname).should_not include(@topic.creator)
    end

  end

end
