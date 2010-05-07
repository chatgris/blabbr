require 'carrierwave/test/matchers'

describe AvatarUploader do
  before do
    @user = Factory.build(:user)
    AvatarUploader.enable_processing = true
    @uploader = AvatarUploader.new(@user, :avatar)
    @uploader.store!(File.open(Rails.root.join("image.jpg")))
  end

  after do
    AvatarUploader.enable_processing = false
  end

  context 'the thumb version' do

    it "should have save an correctly named avatar in images/avatars" do
      @uploader.url.should == "/images/avatars/#{@user.permalink}.jpg"
    end

  end

end
