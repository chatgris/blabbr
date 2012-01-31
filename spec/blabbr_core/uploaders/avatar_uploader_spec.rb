# encoding: utf-8
require 'spec_helper'
require 'carrierwave/test/matchers'

describe BlabbrCore::AvatarUploader do
  let(:user) { Factory :user }

  before do
    described_class.enable_processing = true
    @uploader = described_class.new(user, :avatar)
    @uploader.store!(image_path)
  end

  after do
    described_class.enable_processing = false
    @uploader.remove!
  end

  it 'should have url method' do
    @uploader.url.should eq "/avatars/#{user.limace}.png"
  end

  it 'should have url methodi for thumb version' do
    @uploader.thumb.url.should eq "/avatars/thumb_#{user.limace}.png"
  end

end
