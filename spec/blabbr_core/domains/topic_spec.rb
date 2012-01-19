# encoding: utf-8
require 'spec_helper'

describe BlabbrCore::Topic do
  let(:current_user) { Factory :user }
  let!(:topic)       { Factory :topic, author: current_user }
  let(:user)         { Factory :user }
  let(:admin)        { Factory :admin }

  context 'with a current_user' do
    it 'it should find all topics' do
      BlabbrCore::Topic.new(current_user).all.to_a.should eq [topic]
    end

    it 'should find a specific topic' do
      BlabbrCore::Topic.new(current_user).find(topic.limace).should eq topic
    end

  end

  context 'with an admin' do
    it 'it should find all topics' do
      BlabbrCore::Topic.new(admin).all.to_a.should eq [topic]
    end

    it 'should find a specific topic' do
      BlabbrCore::Topic.new(admin).find(topic.limace).should eq topic
    end

  end

  context 'with a member' do
    before do
      topic.members.create(user: user)
    end

    it 'it should find all topics' do
      BlabbrCore::Topic.new(user).all.to_a.should eq [topic]
    end

    it 'should find a specific topic' do
      BlabbrCore::Topic.new(user).find(topic.limace).should eq topic
    end
  end

  context 'with a user' do
    it 'it should find all topics' do
      BlabbrCore::Topic.new(user).all.to_a.should_not be_any
    end

    it 'should not find a specific topic' do
      lambda {
        BlabbrCore::Topic.new(user).find(topic.limace)
      }.should raise_error
    end
  end

  context 'without a user' do
    it 'it should raise on :all' do
      lambda {BlabbrCore::Topic.new.all}.should raise_error
    end

    it 'it should raise on :find' do
      lambda {BlabbrCore::Topic.new.find(topic.limace)}.should raise_error
    end
  end
end
