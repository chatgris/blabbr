require 'spec_helper'

describe Post do

  it { Post.fields.keys.should be_include('body')}
  it { Post.fields['body'].type.should == String}

  it { Post.fields.keys.should be_include('state')}
  it { Post.fields['state'].type.should == String}

  describe 'validation' do
    it 'should required title' do
      Factory.build(:post, :user_id => '').should_not be_valid
    end

    it 'should required permalink' do
      Factory.build(:post, :body => '').should_not be_valid
    end

    it 'should validates body.size' do
      Factory.build(:post, :body => (0...10100).map{65.+(rand(25)).chr}.join).should_not be_valid
    end

  end

  describe "callback" do

    context "When a post is created" do
      before :each do
        @creator  = Factory.create(:creator)
        @member = Factory.create(:user)
        @topic = Factory.create(:topic)
        @post = Factory.build(:post, :user_id => @creator.id)
        @post.topic = @topic
      end

      it "should increment creator.posts_count at creation" do
        @creator.reload.posts_count.should == 13
      end

      it "should increment user.posts_count when a new post is created" do
        @post.save
        User.by_nickname(@creator.nickname).first.posts_count.should == 14
      end

      it "should have a correct user_id for the first post" do
        @post.save
        @post.reload.user_id.should == @creator.id
      end

      it "should increment topic.posts_count when a new post is created" do
        @post.save
        @topic.reload.posts_count.should == 2
      end

      it "should update posted_at time" do
        sleep(2)
        @post.save
        @topic.reload.posted_at.to_s.should_not == @topic.created_at.to_s
      end

      it "shouldn't add a post if body is not present" do
        @topic.reload.posts.size.should == 1
        @post = Factory.build(:post, :user_id => @creator.id, :body => "")
        @post.save
        @topic.reload.posts.size.should == 1
      end
    end

    context "when a post is added by a member" do

      before :each do
        @creator  = Factory.create(:creator)
        @member = Factory.create(:user)
        @topic = Factory.create(:topic)
        @post = Factory.build(:post, :user_id => @member.id)
        @post.topic = @topic
        @topic.new_member(@member.nickname)
        @post.save
      end

      it "should have increment posts_count when a new post is added by user" do
        @topic.reload.members[1].posts_count.should == 1
      end

      it "shouldn't increment posts_count of creator in this context" do
        @topic.reload.members[0].posts_count.should == 1
      end

      it "should increment unread count when a post is added" do
        @topic.reload.members[1].unread.should == 2
      end

      it "should reset unread post" do
        @topic.reload.members[1].unread.should == 2
        @topic.reset_unread(@member.nickname)
        @topic.reload.members[1].unread.should == 0
        @topic.reload.members[0].unread.should_not == 0
      end

      it "should add post_id to member" do
        @topic.reload.members[0].post_id.should == @topic.reload.posts[1].id.to_s
      end

      it "should add page number of the newly added post to member" do
        @topic.reload.members[1].page.should == @topic.reload.posts_count / PER_PAGE + 1
      end
    end
  end

end
