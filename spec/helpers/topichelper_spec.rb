require 'spec_helper'


def current_user(stubs = {})
  @current_user ||= Factory.create(:chatgris)
end

describe TopicHelper do
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
      helper.textilize("!http://www.example.com/image.jpg!").should == "<p><img src=\"http://www.example.com/image.jpg\" /></p>"
    end

    it "should allow link on images" do
      helper.textilize("!http://www.example.com/image.jpg!:http://example.com/link").should == "<p><a href=\"http://example.com/link\"><img src=\"http://www.example.com/image.jpg\" /></a></p>"
    end

    it "should allow link tag" do
      helper.textilize("\"link\":http://redcloth.org").should == "<p><a href=\"http://redcloth.org\">link</a></p>"
    end

    it "should escape javascript" do
      helper.textilize("<script type=\"text/javascript\">alert(\"test\");</script>").should == "alert(\"test\");"
    end

    it "should allow smilies" do
      helper.textilize("Test de smiley :doc:").should == "<p>Test de smiley <img src=\"/uploads/smilies/doc.jpg\" alt=\"doc\" /></p>"
    end
  end

  describe "ratio links" do

    before :all do
      @current_user = Factory.create(:chatgris)
      @topic = Factory.create(:topic)
    end

    it "should display posts ratio" do
      helper.post_ratio(@topic).should == "1/1"
    end

    it "should display attachments ratio" do
      helper.attachments_ratio(@topic).should == "0/0"
    end
  end
end
