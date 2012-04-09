# encoding: utf-8
require 'spec_helper'

describe BlabbrCore::Topic do
  let(:current_user) { FactoryGirl.create :user }
  let!(:topic)       { FactoryGirl.create :topic, author: current_user }
  let(:user)         { FactoryGirl.create :user }
  let(:admin)        { FactoryGirl.create :admin }

  context 'with a current_user' do
    let(:domain) {
      BlabbrCore::Topic.new(current_user, topic.limace)
    }

    it 'should find a specific topic' do
      domain.find.should eq topic
    end

    it 'should be able to add posts' do
      domain.add_post(body: "My new post").should be_true
    end

    it 'should be able to upadate posts' do
      domain.add_post(body: "My new post")
      domain.update_post(topic.posts.first.id.to_s, body: "My new post").should be_true
    end
  end

  context 'with an admin' do
    let(:domain) {
      BlabbrCore::Topic.new(admin, topic.limace)
    }

    it 'should find a specific topic' do
      BlabbrCore::Topic.new(admin, topic.limace).find.should eq topic
    end

    it 'should be able to add posts' do
      domain.add_post(body: "My new post").should be_true
    end

    it 'should be able to upadate posts' do
      domain.add_post(body: "My new post")
      domain.update_post(topic.posts.first.id.to_s, body: "My new post").should be_true
    end
  end

  context 'with a member' do
    let(:domain) {
      BlabbrCore::Topic.new(user, topic.limace)
    }

    before do
      topic.members.create(user: user)
    end

    it 'should find a specific topic' do
      BlabbrCore::Topic.new(user, topic.limace).find.should eq topic
    end

    it 'should be able to add posts' do
      domain.add_post(body: "My new post").should be_true
    end
  end

  context 'with a user' do
    let(:domain) {
      BlabbrCore::Topic.new(user, topic.limace)
    }

    it 'should not find a specific topic' do
      lambda {
        BlabbrCore::Topic.new(user, topic.limace).find
      }.should raise_error
    end

    it 'should not be able to add posts' do
      lambda {
        domain.add_post(body: "My new post")
      }.should raise_error
    end

    it 'should not be able to update posts' do
      topic.posts.create(author: topic.author, body: 'Not able to update')
      lambda {
        domain.update_post(topic.posts.first.id.to_s, body: "My new post")
      }.should raise_error
    end
  end

  context 'without a user' do
    let(:domain) {
      BlabbrCore::Topic.new(user, topic.limace)
    }

    it 'it should raise on :find' do
      lambda {BlabbrCore::Topic.new.find}.should raise_error
    end

  end
end
