require 'carrierwave/test/matchers'

describe AttachmentUploader do
  before do
    @user = Factory.build(:user)
    @topic = Factory.build(:topic)
    AttachmentUploader.enable_processing = true
    @uploader = AttachmentUploader.new(@topic, :attachment)
    @uploader.store!(File.open(Rails.root.join("image.jpg")))
  end

  after do
    AttachmentUploader.enable_processing = false
  end

  it "should have save an correctly attachment in images/topic.permalink" do
    @uploader.url.should == "/images/#{@topic.permalink}/image.jpg"
  end

end
