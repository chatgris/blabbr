require 'spec_helper'
require 'carrierwave/test/matchers'

describe SmileyUploader do
  before do
    @smiley = Factory.build(:smiley)
    SmileyUploader.enable_processing = true
    @uploader = SmileyUploader.new(@smiley, :smiley)
    @uploader.store!(File.open(Rails.root.join("image.jpg")))
  end

  after do
    SmileyUploader.enable_processing = false
  end

  context 'the thumb version' do

    it "should have save an correctly named avatar in images/avatars" do
      @uploader.url.should == "/uploads/smilies/#{@smiley.code}.jpg"
    end

  end

end
