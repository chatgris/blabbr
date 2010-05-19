require 'spec_helper'

describe Topic do
  describe "textilize" do

    def textilize(text)
      Textilizer.new(text).to_html
    end

    before do
      @smiley = Factory.build(:smiley)
      @smiley.image = File.open(Rails.root.join("image.jpg"))
      @smiley.save
    end

    it "should do basic textile" do
      textilize("hello *world*").should == "<p>hello <strong>world</strong></p>"
    end

    it "should allow img tag" do
      textilize("!http://www.example.com/image.jpg!").should == "<p><img src=\"http://www.example.com/image.jpg\" /></p>"
    end

    it "should allow link on images" do
      textilize("!http://www.example.com/image.jpg!:http://example.com/link").should == "<p><a href=\"http://example.com/link\"><img src=\"http://www.example.com/image.jpg\" /></a></p>"
    end

    it "should allow link tag" do
      textilize("\"link\":http://redcloth.org").should == "<p><a href=\"http://redcloth.org\">link</a></p>"
    end

    it "should escape javascript" do
      textilize("<script type=\"text/javascript\">alert(\"test\");</script>").should == "alert(\"test\");"
    end

    it "should allow smilies" do
      textilize("Test de smiley :doc:").should == "<p>Test de smiley <img src=\"/uploads/smilies/doc.jpg\" alt=\"doc\" /></p>"
    end
  end

end
