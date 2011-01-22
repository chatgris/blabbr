require 'spec_helper'

describe AvatarUploader do
  before do
    @user = Fabricate(:user)
    AvatarUploader.enable_processing = true
    @uploader = AvatarUploader.new(@user, :avatar)
    @uploader.store!(File.open(Rails.root.join("image.jpg")))
  end

  after do
    AvatarUploader.enable_processing = false
  end

  it "should have save an correctly named avatar in images/avatars" do
    @uploader.url.should == "/uploads/avatars/#{@user.slug}.jpg"
  end

end
