require 'spec_helper'

describe User do

  before :all do
    @user = Factory.build(:user)
  end

  it { User.fields.keys.should be_include('nickname')}
  it { User.fields['nickname'].type.should == String}

  it { User.fields.keys.should be_include('email')}
  it { User.fields['email'].type.should == String}

  it { User.fields.keys.should be_include('permalink')}
  it { User.fields['permalink'].type.should == String}

  it { User.fields.keys.should be_include('locale')}
  it { User.fields['locale'].type.should == String}

  it { User.fields.keys.should be_include('note')}
  it { User.fields['note'].type.should == String}

  it { User.fields.keys.should be_include('posts_count')}
  it { User.fields['posts_count'].type.should == Integer}

  it { User.fields.keys.should be_include('gravatar_url')}
  it { User.fields['gravatar_url'].type.should == String}

  it { User.fields.keys.should be_include('attachments_count')}
  it { User.fields['attachments_count'].type.should == Integer}

  it "should be valid" do
    @user.should be_valid
  end

  describe 'validation' do
    it 'should required nickname' do
      Factory.build(:user, :nickname => '').should_not be_valid
    end

    it 'should required permalink' do
      Factory.build(:user, :permalink => '', :nickname => '').should_not be_valid
    end

    it 'should required email' do
      Factory.build(:user, :email => '').should_not be_valid
    end

    it 'should not valid if login is already taken' do
      Factory.create(:user)
      Factory.build(:user, :nickname => 'one_user').should_not be_valid
    end

    it 'should not valid if email is already taken' do
      Factory.build(:user, :email => 'email@mail.com').should_not be_valid
    end

    it "should have a valid permalink" do
      User.by_permalink(@user.permalink).first.permalink.should == @user.nickname.parameterize
    end

    it "should set a gravatar_url" do
      User.by_permalink(@user.permalink).first.gravatar_url.should == "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(@user.email.downcase.strip)}.jpg?size=80"
    end
  end

  describe 'named_scope' do

    before :all do
      @user = Factory.create(:user)
    end

    it "should be find by permalink" do
      User.by_permalink(@user.permalink).first.permalink.should == @user.permalink
    end

    it "should be find by nickname" do
      User.by_nickname(@user.nickname).first.nickname.should == @user.nickname
    end

  end

  describe "associations" do

     it "should embed many attachments" do
      association = User.associations['attachments']
      association.klass.should ==(Attachment)
      association.association.should ==(Mongoid::Associations::EmbedsMany)
    end
  end

end
