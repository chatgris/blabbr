# encoding: utf-8
require 'spec_helper'

describe BlabbrCore::Member do
  describe 'Fields' do
    it { should have_fields(:unread, :posts_count).of_type(Integer) }
  end

  describe 'Relations' do
    it { should be_embedded_in(:topic) }
    it { should belong_to(:user).of_type(BlabbrCore::User) }
  end

  describe 'validations' do
    it 'should have a valid factory' do
      Factory.build(:member).should be_valid
    end
  end
end
