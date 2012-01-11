# encoding: utf-8
require 'spec_helper'

describe BlabbrCore::Member do
  let(:topic) { Factory :topic }

  describe 'Fields' do
    it { should have_fields(:unread, :posts_count).of_type(Integer) }
    it { should have_fields(:post_id).of_type(String) }
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

  describe 'reset_unread' do
    it 'should set unread to 0, without save' do
      member = topic.members.first
      member.unread = 42
      member.save.should be_true
      member.unread.should eq 42
      member.reset_unread
      member.unread.should eq 0
      member.reload.unread.should_not eq 0
    end

    it 'should set unread to 0, with save' do
      member = topic.members.first
      member.unread = 42
      member.save.should be_true
      member.unread.should eq 42
      member.reset_unread!
      member.unread.should eq 0
      member.reload.unread.should eq 0
    end
  end
end
