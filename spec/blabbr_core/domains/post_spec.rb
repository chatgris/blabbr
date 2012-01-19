# encoding: utf-8
require 'spec_helper'

describe BlabbrCore::Post do
  let(:current_user) { Factory :user }
  let(:topic)        { Factory :topic, author: current_user }
  let!(:post)        { Factory :post, author: current_user, topic: topic }
  let(:user)         { Factory :user }
  let(:admin)        { Factory :admin }

  context 'with a current_user' do
    it 'it should find all posts' do
      BlabbrCore::Post.new(current_user).all.to_a.should eq [post]
    end

    it 'should find a specific post' do
      BlabbrCore::Post.new(current_user).find(post.id.to_s).should eq post
    end

  end

  context 'with an admin' do
    it 'it should find all posts' do
      BlabbrCore::Post.new(admin).all.to_a.should eq [post]
    end

    it 'should find a specific post' do
      BlabbrCore::Post.new(admin).find(post.id.to_s).should eq post
    end

  end

  context 'with a member' do
    before do
      topic.members.create(user: user)
    end

    it 'it should find all posts' do
      BlabbrCore::Post.new(user).all.to_a.should eq [post]
    end

    it 'should find a specific post' do
      BlabbrCore::Post.new(user).find(post.id.to_s).should eq post
    end
  end

  context 'with a user' do
    it 'it should find all posts' do
      BlabbrCore::Post.new(user).all.to_a.should be_any
    end

    it 'should not find a specific post' do
      lambda {
      BlabbrCore::Post.new(user).find(post.id.to_s)
      }.should raise_error
    end
  end

  context 'without a user' do
    it 'it should raise on :all' do
      lambda {BlabbrCore::Post.new.all}.should raise_error
    end

    it 'it should raise on :find' do
      lambda {BlabbrCore::Post.new.find(post.id.to_s)}.should raise_error
    end
  end
end
