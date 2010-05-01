require 'spec_helper'

describe User do

  before :all do
    @user = Factory.build(:user)
    @user.save
  end

  it "should be valid" do
    @user.should be_valid
  end

  it "should have a valid permalink" do
    @user.permalink.should == @user.nickname.parameterize
  end

  it "should be find by permalink" do
    User.by_permalink(@user.permalink).first.permalink.should == @user.permalink
  end

  it "should be find by nickname" do
    User.by_nickname(@user.nickname).first.nickname.should == @user.nickname
  end

  describe "validations" do
    it { should validate_presence_of(:nickname) }
    it { should validate_presence_of(:permalink) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:identity_url) }
  end

end
