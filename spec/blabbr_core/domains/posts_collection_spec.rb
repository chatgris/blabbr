# encoding: utf-8
require 'spec_helper'

describe BlabbrCore::PostsCollection do
  let(:current_user) { Factory :user }
  let(:topic)        { Factory :topic, author: current_user }
  let!(:post)        { Factory :post, author: current_user, topic: topic }
  let(:user)         { Factory :user }
  let(:admin)        { Factory :admin }

  context 'with a current_user' do
    it 'it should find all posts' do
      BlabbrCore::PostsCollection.new(current_user, topic).all.to_a.should eq [post]
    end
  end

  context 'with an admin' do
    it 'it should find all posts' do
      BlabbrCore::PostsCollection.new(admin, topic).all.to_a.should eq [post]
    end
  end

  context 'with a member' do
    before do
      topic.members.create(user: user)
    end

    it 'it should find all posts' do
      BlabbrCore::PostsCollection.new(user, topic).all.to_a.should eq [post]
    end
  end

  context 'with a user' do
    it 'it should find all posts' do
      BlabbrCore::PostsCollection.new(user, topic).all.to_a.should be_any
    end
  end

  context 'without a user' do
    it 'it should raise on :all' do
      lambda {BlabbrCore::PostsCollection.new.all}.should raise_error
    end
  end
end
