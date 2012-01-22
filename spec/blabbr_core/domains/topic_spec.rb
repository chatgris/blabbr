# encoding: utf-8
require 'spec_helper'

describe BlabbrCore::Topic do
  let(:current_user) { Factory :user }
  let!(:topic)       { Factory :topic, author: current_user }
  let(:user)         { Factory :user }
  let(:admin)        { Factory :admin }

  context 'with a current_user' do
    it 'should find a specific topic' do
      BlabbrCore::Topic.new(current_user, topic.limace).find.should eq topic
    end
  end

  context 'with an admin' do
    it 'should find a specific topic' do
      BlabbrCore::Topic.new(admin, topic.limace).find.should eq topic
    end
  end

  context 'with a member' do
    before do
      topic.members.create(user: user)
    end

    it 'should find a specific topic' do
      BlabbrCore::Topic.new(user, topic.limace).find.should eq topic
    end
  end

  context 'with a user' do
    it 'should not find a specific topic' do
      lambda {
        BlabbrCore::Topic.new(user, topic.limace).find
      }.should raise_error
    end
  end

  context 'without a user' do
    it 'it should raise on :find' do
      lambda {BlabbrCore::Topic.new.find}.should raise_error
    end
  end
end
