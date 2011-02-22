require 'spec_helper'

describe Post do

  describe 'relations' do
    it { should be_referenced_in(:user) }
    it { should be_referenced_in(:topic) }
  end

  describe 'fields' do
    it { should have_fields(:body, :state).of_type(String) }
  end

  describe 'validation' do
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:user_id) }
    it { should validate_length_of(:body) }
  end

  context "Setup : topic, user, and cretor created" do

    let(:creator) do
      Factory.create(:creator)
    end

    let(:member) do
      Factory.create(:user)
    end

    let(:topic) do
      Factory.create(:topic, :user => creator)
    end

    let(:post) do
      Factory.build(:post, :creator => creator, :t => topic)
    end

    describe "callback" do
      context "When a post is created" do
        before :each do
          post.topic = topic
          post.save
        end

        it "should increment creator.posts_count at creation" do
          creator.reload.posts_count.should == 14
        end

        it "should increment topic.posts.count when a new post is created" do
          topic.reload.posts.count.should == 2
        end

        it "should increment user.posts_count when a new post is created" do
          creator.reload.posts_count.should == 14
        end

        it "should have a correct user_id for the first post" do
          post.reload.user_id.should == creator.id
        end

        it "should increment topic.posts_count when a new post is created" do
          topic.reload.posts_count.should == 2
        end

      end

      context "When a post is created, next" do

        it "should update posted_at time" do
          sleep(1)
          post.topic = topic
          topic.reload.posted_at.to_s.should_not == topic.created_at.to_s
        end

        it "shouldn't add a post if body is not present" do
          post.body = ''
          post.topic = topic
          topic.reload.posts.size.should == 1
        end
      end

      context "when a post is added by a member" do

        let(:new_post) do
          Factory.build(:post, :creator => member, :t => topic)
        end

        before :each do
          topic.new_member(member.nickname)
          new_post.topic = topic
          new_post.save
        end

        it "should have 2 members" do
          topic.reload.members.count.should == 2
        end

        it "should have increment posts_count when a new post is added by user" do
          topic.reload.members[1].posts_count.should == 1
        end

        it "shouldn't increment posts_count of creator in this context" do
          topic.reload.members[0].posts_count.should == 1
        end

        it "shouldn't increment unread count when a post is added by the same user" do
          topic.reload.members[1].unread.should == 1
        end

        it "should increment unread count when a post is added" do
          topic.reload.members[1].unread.should == 1
          post.topic = topic
          post.save
          topic.reload.members[1].unread.should == 2
        end

        it "should reset unread post" do
          topic.reload.members[1].unread.should == 1
          topic.reset_unread(member.nickname)
          topic.reload.members[1].unread.should == 0
          topic.reload.members[0].unread.should_not == 0
        end

        it "should add post_id to member" do
          topic.reload.members[0].post_id.should == topic.reload.posts[1].id.to_s
        end

        it "should add page number of the newly added post to member" do
          topic.reload.members[1].page.should == topic.reload.posts_count / PER_PAGE + 1
        end
      end
    end
  end

end
