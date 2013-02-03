# encoding: utf-8
require 'spec_helper'

describe Topic do

  describe 'relation' do
    it {should reference_many(:posts)}
    it {should embed_many(:members)}
    it {should embed_many(:attachments)}
  end

  describe 'fields' do
    it { should have_fields(:creator, :title, :state, :last_user).of_type(String) }
    it { should have_fields(:posts_count).of_type(Integer).with_default_value_of(1)}
    it { should have_fields(:attachments_count).of_type(Integer).with_default_value_of(0)}
    it { should have_fields(:posted_at).of_type(Time) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:posts) }
    it { should validate_uniqueness_of(:title) }
    it { should validate_length_of(:title) }
  end

  context 'set up : topic and user created' do

    let(:creator) { Factory :creator}
    let(:topic) { Factory :topic, :creator => creator.nickname}
    let(:post) { Factory.build(:post)}
    let(:current_user) { Factory :user}
    let(:member) { Factory :user}
    let(:ability_for_creator) { Ability.new(creator)}
    let(:ability_for_member) { Ability.new(member)}
    let(:ability_for_user) { Ability.new(current_user)}

    describe 'Ability' do

      context 'Ability for creator' do
        [:read, :update, :destroy, :rm_member, :add_member].each do |action|
          it "should be possible fot creator to #{action}" do
            ability_for_creator.should be_able_to(action, topic)
          end
        end
      end

      context 'Ability for member' do
        before :each do
          topic.add_member(member.nickname)
        end

        [:update, :destroy, :rm_member, :add_member].each do |action|
          it "should be possible for a creator to #{action}" do
            ability_for_member.should_not be_able_to(action, topic)
          end
        end

        it "should be possible for a member to read" do
          ability_for_member.should be_able_to(:read, topic)
        end
      end

      context 'Ability for  user' do

        [:read, :update, :destroy, :rm_member, :add_member].each do |action|
          it "should be possible for a user to #{action}" do
            ability_for_member.should_not be_able_to(action, topic)
          end
        end
      end

    end

    context "Validations" do

      describe 'validation with context' do

        it "should have a valid slug" do
          topic.reload.slug.should == topic.title.parameterize
        end

        it "should have creator as last_user" do
          topic.reload.last_user.should == creator.nickname
        end

        it 'should not valid if title is already taken' do
          Factory.create(:topic).should be_valid
          Factory.build(:topic).should_not be_valid
        end

        it 'should have a valid posted_add time' do
          topic.reload.posted_at.should be_within(Time.now.to_i - 10).of(Time.now.utc + 10)
        end

        it "should have creator as a member" do
          topic.members[0].nickname.should == topic.creator
        end

        it "should have a member" do
          topic.reload.members.count.should == 1
        end

        it "should have a post" do
          topic.reload.posts_count.should == 1
          topic.reload.posts.all.count.should == 1
          topic.reload.posts.first.body.should == post.body
        end
      end
    end

    describe 'callback' do
      it 'should increment creator posts_count' do
        lambda {
          Factory :topic, :user => creator
        }.should change(creator, :posts_count).by(1)
      end
    end

    describe 'members' do

      let(:post) do
        Factory.build(:post, :user_id => current_user.id)
      end

      let(:member) do
        Factory.build(:member)
      end

      context " Adding new members "do
        it "should have one member" do
          topic.reload.members.size.should == 1
        end

        it "shouldn't add a unregistered user to topic" do
          topic.reload.members.size.should == 1
          topic.add_member(member.nickname)
          topic.reload.members.size.should == 1
        end

        it "should add a registered user to topic" do
          topic.add_member(current_user.nickname)
          topic.reload.members.size.should == 2
        end

        it "should have a posts_count equals to 0 when invited" do
          topic.add_member(current_user.nickname)
          topic.reload.members[1].posts_count.should == 0
        end

        it "shouldn't add a user if this user is already invited" do
          topic.add_member(current_user.nickname)
          topic.reload.members.size.should == 2
        end

        it "should make unread equals to posts.size when a member is invited" do
          topic.add_member(current_user.nickname)
          topic.reload.members[1].unread.should == topic.reload.posts.count
        end
      end
    end

    describe 'attachments' do

      context "Default status" do
        it "should have a member.attachments_count equals to 0" do
          topic.reload.members[0].attachments_count.should == 0
        end
      end

      context "Topic related callbacks" do
        it "should increment member.attachments_count when a new attachment is added" do
          topic.new_attachment(creator.nickname, File.open(Rails.root.join("image.jpg")))
          topic.reload.members[0].attachments_count.should == 1
          topic.reload.attachments_count.should == 1
        end

      end

    end

    describe 'stateflow' do

      let(:current_user) do
        Factory.create(:creator)
      end

      context "By default" do
        it "should be set to published by default" do
          topic.state.should == "published"
        end

        it "should set a topic as deleted" do
          lambda {
            topic.delete!
          }.should change(topic, :state).from('published').to('deleted')
        end
      end

      context "When a Topic is set to deleted" do
        before :each do
          topic.delete!
        end

        it "should set a deleted topic as published" do
          lambda {
            topic.publish!
          }.should change(topic, :state).from('deleted').to('published')
        end
      end

    end

    describe 'scope' do

      it "should find by slug" do
        Topic.by_slug(topic.reload.slug).first.title.should == topic.title
        Topic.by_slug("Does not exist").first.should be_nil
      end

      it "should find by creator" do
        Topic.for_creator(topic.reload.creator).first.title.should == topic.title
        Topic.for_creator("Does not exist").first.should be_nil
      end

      it "should find by subscribed topic" do
        Factory.create(:topic)
        Topic.by_subscribed_topic(creator.nickname).first.should_not be_nil
        Topic.by_subscribed_topic("Not a user").first.should be_nil
      end
    end
  end
end
