# encoding: utf-8
require 'spec_helper'

describe AvatarUploader do
  before do
    @user = Factory.create(:user)
    AvatarUploader.enable_processing = true
    @uploader = AvatarUploader.new(@user, :avatar)
    @uploader.store!(File.open(Rails.root.join("image.jpg")))
  end

  after do
    AvatarUploader.enable_processing = false
  end

  it "should have save an correctly named avatar in images/avatars" do
    @uploader.url.should == "/uploads/avatars/#{@user.slug}.png"
  end

end
