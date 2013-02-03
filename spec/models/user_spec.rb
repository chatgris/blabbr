# encoding: utf-8
require 'spec_helper'

describe User do

  describe 'relation' do
    it {should embed_many(:attachments)}
  end

  describe 'fields' do
    it { should have_fields(:nickname, :email, :locale, :time_zone, :note).of_type(String) }
    it { should have_fields(:audio).of_type(Boolean).with_default_value_of(true)}
    it { should have_fields(:posts_count).of_type(Integer).with_default_value_of(0)}
    it { should have_fields(:attachments_count).of_type(Integer).with_default_value_of(0)}
  end

  describe 'validations' do
    it { should validate_presence_of(:nickname) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:nickname) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_length_of(:nickname) }
    it { should validate_format_of(:email).to_allow("valid@mail.com").not_to_allow("invalidmail") }
  end

  context 'with a user' do
    let(:user) do
      Factory.create(:user)
    end

    describe 'named_scope' do
      it "should be find by slug" do
        User.by_slug(user.nickname.parameterize).first.nickname.should == user.nickname
      end

      it "should be find by nickname" do
        User.by_nickname(user.nickname).first.nickname.should == user.nickname
      end
    end

    describe "User preferences" do
      it "should update time_zone" do
        user.time_zone = 'Paris'
        user.save
        user.reload.time_zone.should == 'Paris'
      end

      it 'should update audio preference' do
        user.audio.should == true
        user.audio = false
        user.reload.audio == false
      end
    end

  end

end
