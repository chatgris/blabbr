require 'spec_helper'

describe AttachmentUploader do
  before do
    @topic = Fabricate(:topic)
    AttachmentUploader.enable_processing = true
    @uploader = AttachmentUploader.new(@topic, :attachment)
    @uploader.store!(File.open(Rails.root.join("image.jpg")))
  end

  after do
    AttachmentUploader.enable_processing = false
  end

  it "should have save an correctly attachment in images/topic.slug" do
    @uploader.url.should == "/uploads/attachments/image.jpg"
  end

end
