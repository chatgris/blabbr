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
    it { should validate_presence_of(:post) }
    it { should validate_uniqueness_of(:title) }
    it { should validate_length_of(:title) }
    it { should validate_length_of(:post) }
  end

  context 'set up : topic and user created' do

    let(:creator) do
      Factory.create(:creator)
    end

    let(:topic) do
      Factory.create(:topic)
    end

    let(:post) do
      Factory.build(:post)
    end

    let(:current_user) do
      Factory.create(:user)
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
          topic.new_member(member.nickname)
          topic.reload.members.size.should == 1
        end

        it "should add a registered user to topic" do
          topic.new_member(current_user.nickname)
          topic.reload.members.size.should == 2
        end

        it "should have a posts_count equals to 0 when invited" do
          topic.new_member(current_user.nickname)
          topic.reload.members[1].posts_count.should == 0
        end

        it "shouldn't add a user if this user is already invited" do
          topic.new_member(current_user.nickname)
          topic.reload.members.size.should == 2
        end

        it "should make unread equals to posts.size when a member is invited" do
          topic.new_member(current_user.nickname)
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
          topic.reload.state.should == "published"
        end

        it "should set a topic as deleted" do
          topic.delete!
          topic.reload.state.should == "deleted"
        end
      end

      context "When a Topic is set to deleted" do
        before :each do
          topic.delete!
        end

        it "should set a deleted topic as published" do
          topic.publish!
          topic.reload.state.should == "published"
        end
      end

    end

    describe 'named_scope' do

      it "should find by slug" do
        Topic.by_slug(topic.reload.slug).first.title.should == topic.title
        Topic.by_slug("Does not exist").first.should be_nil
      end

      it "should find by subscribed topic" do
        Factory.create(:topic)
        Topic.by_subscribed_topic(creator.nickname).first.should_not be_nil
        Topic.by_subscribed_topic("Not a user").first.should be_nil
      end
    end
  end
end
