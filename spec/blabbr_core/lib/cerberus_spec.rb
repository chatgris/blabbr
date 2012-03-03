# encoding: utf-8
require 'spec_helper'

describe BlabbrCore::Cerberus do
  let(:ability)      { BlabbrCore::Ability }
  let(:user)         { double }
  let(:current_user) { Factory :user }
  let(:topic)        { Factory :topic, author: current_user }
  let(:post)         { Factory :post, topic: topic, author: current_user }

  [BlabbrCore::UsersCollection, BlabbrCore::PostsCollection, BlabbrCore::TopicsCollection].each do |klass|
    describe klass do
      context 'admin' do
        before do
          user.stub!(:admin?).and_return(true)
        end

        it 'should be able to all' do
          ability.new(user, :all, klass, nil).should be_valid
        end
      end

      context 'user' do
        before do
          user.stub!(:admin?).and_return(false)
        end

        it 'should be able to all' do
          ability.new(user, :all, klass, nil).should be_valid
        end
      end
    end
  end

  describe 'User ability' do
    context 'admin' do
      before do
        user.stub!(:admin?).and_return(true)
      end

      [:update, :find, :create, :activate, :activate!, :ban, :ban!].each do |method|
        it "should be able to #{method} a user" do
          ability.new(user, method, BlabbrCore::User, nil).should be_valid
        end
      end
    end

    context 'user' do
      before do
        user.stub!(:admin?).and_return(false)
      end

      [:update, :create, :activate, :activate!, :ban, :ban!].each do |method|
        it "should be able to #{method} a user" do
          ability.new(user, method, BlabbrCore::User, nil).should_not be_valid
        end
      end
      it "should be able to update a user" do
        ability.new(user, :update, BlabbrCore::User, nil).should_not be_valid
      end

      it "should be able to update self" do
        ability.new(user, :update, BlabbrCore::User, user).should be_valid
      end
    end
  end

  describe 'Topic ability' do
    context 'admin' do
      before do
        user.stub!(:admin?).and_return(true)
      end

      [:update, :find, :create, :add_post].each do |method|
        it "should be able to #{method} a topic" do
          ability.new(user, method, BlabbrCore::Topic, nil).should be_valid
        end
      end
    end

    context 'member' do
      let(:user) { Factory :user }

      before do
        topic.members.create(user: user)
      end

      [:find, :create, :add_post].each do |method|
        it "should not be able to #{method} a topic" do
          ability.new(user, method, BlabbrCore::Topic, topic).should be_valid
        end
      end

      [:update].each do |method|
        it "should not be able to #{method} a topic" do
          ability.new(user, method, BlabbrCore::Topic, topic).should_not be_valid
        end
      end
    end

    context 'author' do
      [:find, :create, :add_post, :update].each do |method|
        it "should be able to #{method} a topic" do
          ability.new(current_user, method, BlabbrCore::Topic, topic).should be_valid
        end
      end
    end

    context 'user' do
      before do
        user.stub!(:admin?).and_return(false)
      end

      [:update, :find, :add_post].each do |method|
        it "should not be able to #{method} a topic" do
          ability.new(user, method, BlabbrCore::Topic, nil).should_not be_valid
        end
      end

      it "should be able to create a topic" do
        ability.new(user, :create, BlabbrCore::Topic, nil).should be_valid
      end
    end
  end

  describe 'Post' do
    context 'admin' do
      before do
        user.stub!(:admin?).and_return(true)
      end

      [:update, :create, :find, :published, :published!, :unpublished, :unpublished!].each do |method|
        it "should be able to #{method} a topic" do
          ability.new(user, method, BlabbrCore::Post, post).should be_valid
        end
      end
    end

    context 'author' do
      [:update, :create, :find, :published, :published!, :unpublished, :unpublished!].each do |method|
        it "should be able to #{method} a topic" do
          ability.new(post.author, method, BlabbrCore::Post, post).should be_valid
        end
      end
    end

    context 'member' do
      let(:user) { Factory :user }

      before do
        topic.members.create(user: user)
      end

      [:find, :create].each do |method|
        it "should be able to #{method} a topic" do
          ability.new(user, method, BlabbrCore::Post, post).should be_valid
        end
      end

      [:update, :published, :published!, :unpublished, :unpublished!].each do |method|
        it "should not be able to #{method} a post" do
          ability.new(user, method, BlabbrCore::Post, post).should_not be_valid
        end
      end
    end
  end
end
