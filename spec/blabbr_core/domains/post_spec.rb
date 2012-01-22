# encoding: utf-8
require 'spec_helper'

describe BlabbrCore::Post do
  let(:current_user) { Factory :user }
  let(:topic)        { Factory :topic, author: current_user }
  let!(:post)        { Factory :post, author: current_user, topic: topic }
  let(:user)         { Factory :user }
  let(:admin)        { Factory :admin }

  context 'with a current_user' do
    let(:domain_post) {
      BlabbrCore::Post.new(current_user, topic, post.id.to_s)
    }

    it 'should find a specific post' do
      BlabbrCore::Post.new(current_user, topic, post.id.to_s).find.should eq post
    end

    it 'should be published by default' do
      domain_post.should be_published
    end

    it 'should be able to published post' do
      domain_post.published
      domain_post.should be_published
    end

    it 'should be able to unpublished! post' do
      domain_post.unpublished!
      domain_post.should be_unpublished
    end

  end

  context 'with an admin' do
    let(:domain_post) {
      BlabbrCore::Post.new(admin, topic, post.id.to_s)
    }

    it 'should find a specific post' do
      BlabbrCore::Post.new(admin, topic, post.id.to_s).find.should eq post
    end

    it 'should be published by default' do
      domain_post.should be_published
    end

    it 'should be able to published post' do
      domain_post.published
      domain_post.should be_published
    end

    it 'should be able to unpublished! post' do
      domain_post.unpublished!
      domain_post.should be_unpublished
    end
  end

  context 'with a member' do
    let(:domain_post) {
      BlabbrCore::Post.new(user, topic, post.id.to_s)
    }

    before do
      topic.members.create(user: user)
    end

    it 'should find a specific post' do
      BlabbrCore::Post.new(user, topic, post.id.to_s).find.should eq post
    end

    it 'should be published by default' do
      domain_post.should be_published
    end

    it 'should not be able to published other user posts' do
      lambda {
        domain_post.published
      }.should raise_error
    end

    it 'should not be able to unpublished! other user posts' do
      lambda {
        domain_post.unpublished!
      }.should raise_error
    end
  end

  context 'with a user' do
    it 'should not find a specific post' do
      lambda {
        BlabbrCore::Post.new(user, topic, post.id.to_s).find
      }.should raise_error
    end
  end

  context 'without a user' do
    it 'it should raise on :find' do
      lambda {BlabbrCore::Post.new.find(post.id.to_s)}.should raise_error
    end
  end
end
