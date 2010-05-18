require 'spec_helper'

describe Topic do
  def textilize(text)
    Textilizer.new(text).to_html
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

end
