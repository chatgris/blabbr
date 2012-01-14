# encoding: utf-8
require 'spec_helper'

describe BlabbrCore::Persistence::User do
  let(:user) { Factory :user }

  describe 'Fields' do
    it { should have_fields(:email, :nickname).of_type(String) }
    it { should have_fields(:posts_count).of_type(Integer) }

    describe 'default values' do
      it 'should have a posts_count of 0' do
        user.posts_count.should eq 0
      end
    end
  end

  describe 'Relations' do
    it { should have_many(:topics).with_foreign_key(:user_id) }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:nickname) }
    it { should validate_length_of(:nickname).within(8..42) }
    it { should validate_uniqueness_of(:nickname) }

    it 'should have a valid factory' do
      user.should be_valid
    end
  end
end
