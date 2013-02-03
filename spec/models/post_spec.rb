# encoding: utf-8
require 'spec_helper'

describe Post do

  describe 'relations' do
    it { should be_referenced_in(:topic) }
  end

  describe 'fields' do
    it { should have_fields(:body, :state, :creator_n, :creator_s).of_type(String) }
    it { should have_fields(:page).of_type(Integer) }
  end

  describe 'validation' do
    it { should validate_presence_of(:body) }
    it { should validate_length_of(:body) }
  end

  context "Setup : topic, user, and creator created" do

    let(:creator) { Factory :creator}
    let(:member) { Factory :user}
    let(:topic) { Factory :topic, :user => creator}
    let(:post) { Factory.build(:post, :creator => creator)}
    let(:ability_for_creator) { Ability.new(creator)}
    let(:ability_for_member) { Ability.new(member)}

    describe 'Ability' do
      before :all do
        topic.posts << post
      end

      context 'Ability for creator' do
        [:read, :update, :destroy].each do |action|
          it "should be possible fot creator to #{action}" do
            ability_for_creator.should be_able_to(action, post)
          end
        end
      end

      context 'Ability for member' do
        before :each do
          topic.add_member(member.nickname)
        end

        [:update, :destroy].each do |action|
          it "should be possible for a creator to #{action}" do
            ability_for_member.should_not be_able_to(action, post)
          end
        end

        it "should be possible for a member to read" do
          ability_for_member.should be_able_to(:read, post)
        end
      end
    end

    describe "callback" do
      context "When a post is created" do
        it "should increment user.posts_count when a new post is created" do
          topic.save
          lambda {
            post.topic = topic
            post.save
          }.should change(creator, :posts_count).by(1)
        end

        it "should increment topic.posts.count when a new post is created" do
          lambda {
            post.topic = topic
            post.save
          }.should change(topic, :posts_count).by(1)
        end

        it "should have a page" do
          lambda {
            post.topic = topic
            post.save
          }.should change(post, :page).from(nil).to(1)
        end

        it "should have a correct creator nickname for the first post" do
          lambda {
            post.topic = topic
            post.save
          }.should change(post, :creator_n).from(nil).to(creator.nickname)
        end

        it "should have a correct creator slug for the first post" do
          lambda {
            post.topic = topic
            post.save
          }.should change(post, :creator_s).from(nil).to(creator.slug)
        end

        it "should update posted_at time" do
          lambda {
            post.topic = topic
            post.save
          }.should change(topic, :posted_at)
        end

      end

      context "when a post is added by a member" do

        let(:new_post) do
          Factory.build(:post, :creator => member)
        end

        before :each do
          topic.add_member(member.nickname)
          new_post.topic = topic
        end

        it "should have updated the last_user" do
          lambda {
            new_post.save
          }.should change(topic, :last_user).from(creator.nickname).to(member.nickname)
        end

        it "should have increment posts_count when a new post is added by user" do
          lambda {
            new_post.save
          }.should change(topic.members[1], :posts_count).by(1)
        end

        it "shouldn't increment posts_count of creator in this context" do
          lambda {
            new_post.save
          }.should_not change(topic.members[0], :posts_count)
        end

        it "shouldn't increment unread count when a post is added by the same user" do
          lambda {
            new_post.save
          }.should change(topic.members[1], :unread).to(0)
        end

        it "should increment unread count when a post is added" do
          lambda {
            new_post.save
          }.should change(topic.members[0], :unread).by(1)
        end

        it "should reset unread post" do
          new_post.save
          lambda {
            topic.reset_unread(creator.nickname)
          }.should change(topic.members[0], :unread).by(-1)
        end

        it "should add post_id to member" do
          lambda {
            new_post.save
          }.should change(topic.members[0], :post_id)
        end

        it "should add page number of the newly added post to member" do
          PER_PAGE = 1
          topic.reset_unread(member.nickname)
          topic.posts << Factory.build(:post, :creator => member)
          topic.save
          lambda {
            new_post.save
          }.should change(topic.members[1], :page)
        end
      end
    end
  end

end
