# encoding: utf-8
require 'spec_helper'

describe BlabbrCore::TopicsCollection do
  let(:current_user) { FactoryGirl.create :user }
  let!(:topic)       { FactoryGirl.create :topic, author: current_user }
  let(:user)         { FactoryGirl.create :user }
  let(:admin)        { FactoryGirl.create :admin }

  context 'with a current_user' do
    it 'it should find all topics' do
      BlabbrCore::TopicsCollection.new(current_user).all.to_a.should eq [topic]
    end
  end

  context 'with an admin' do
    it 'it should find all topics' do
      BlabbrCore::TopicsCollection.new(admin).all.to_a.should eq [topic]
    end
  end

  context 'with a member' do
    before do
      topic.members.create(user: user)
    end

    it 'it should find all topics' do
      BlabbrCore::TopicsCollection.new(user).all.to_a.should eq [topic]
    end
  end

  context 'with a user' do
    it 'it should find all topics' do
      BlabbrCore::TopicsCollection.new(user).all.to_a.should_not be_any
    end
  end

  context 'without a user' do
    it 'it should raise on :all' do
      lambda {BlabbrCore::TopicsCollection.new.all}.should raise_error
    end
  end
end
