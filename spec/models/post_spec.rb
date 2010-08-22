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
        @topic = Factory.create(:topic)
        @post = Factory.build(:post, :user_id => @creator.id)
        @post.topic = @topic
      end

      it "should increment user.posts_count" do
        @creator.reload.posts_count.should == 13
      end

      it "should increment user.posts_count when a new post is created" do
        User.by_nickname(@creator.nickname).first.posts_count.should == 13
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
    end
  end

end
