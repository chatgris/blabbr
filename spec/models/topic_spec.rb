require 'spec_helper'

describe Topic do

  before :all do
    @topic = Factory.build(:topic)
    @topic.save
    @post = Factory.build(:post)
    @current_user = Factory.build(:user)
    @current_user.save
    @subscriber = Factory.build(:subscriber)
  end

  it { Topic.fields.keys.should be_include('creator')}
  it { Topic.fields['creator'].type.should == String}

  it { Topic.fields.keys.should be_include('title')}
  it { Topic.fields['title'].type.should == String}

  it { Topic.fields.keys.should be_include('permalink')}
  it { Topic.fields['permalink'].type.should == String}

  it { User.fields.keys.should be_include('posts_count')}
  it { User.fields['posts_count'].type.should == Integer}

  it "should be valid" do
    @topic.should be_valid
  end

  describe 'validation' do
    it 'should required title' do
      Factory.build(:topic, :title => '').should_not be_valid
    end

    it 'should required permalink' do
      Factory.build(:topic, :title => '', :permalink => '').should_not be_valid
    end

    it 'should required creator' do
      Factory.build(:topic, :creator => '').should_not be_valid
    end

    it "should required post" do
      Factory.build(:topic, :post => '').should_not be_valid
    end

    it 'should not valid if title is already taken' do
      Factory.create(:topic, :title => 'title')
      Factory.build(:topic, :title => 'title').should_not be_valid
    end

    it 'should not valid if permalink is already taken' do
      Factory.create(:topic, :permalink => 'permalink')
      Factory.build(:topic, :permalink => 'permalink').should_not be_valid
    end

    it "should have a valid permalink" do
      @topic.permalink.should == @topic.title.parameterize
    end

    it "should have creator as a subscriber" do
      @topic.subscribers[0].nickname.should == @topic.creator
    end

    it "should have a post" do
      @topic.posts[0].content.should == @post.content
    end
  end

  describe "callback" do

    before :all do
      @topic = Factory.create(:topic)
      @post = Factory.build(:post)
      @current_user = Factory.create(:user)
      @subscriber = Factory.build(:subscriber)
    end

    it "should increment user.posts_count and unread post when a new post is created" do
      @topic.new_post(@post)
      @topic.save
      User.where(:nickname => @current_user.nickname).first.posts_count.should == 13
      Topic.where(:permalink => @topic.permalink).first.posts.size.should == @topic.posts.size
    end

    it "should increment topic.posts_count when a new post is created" do
      @topic.posts_count.should == 2
      @topic.new_post(@post)
      @topic.posts_count.should == 3
    end

    it "should decrement topic.posts_count when a new post is deleted" do
      @topic.posts_count.should == 3
      @topic.posts.delete_if { |post| post.id == @topic.posts[0].id }
      @topic.save
      @topic.posts_count.should == 2
    end

  end

  describe 'subscribers' do

    before :all do
      @topic = Factory.create(:topic)
      @post = Factory.build(:post)
      @current_user = Factory.create(:user)
      @subscriber = Factory.build(:subscriber)
    end

    it "shouldn't add a unregistered user to topic" do
      @topic.subscribers.size.should == 1
      @topic.new_subscriber(@subscriber.nickname)
      @topic.subscribers.size.should == 1
    end

    it "should add a registered user to topic" do
      @topic.subscribers.size.should == 1
      @topic.new_subscriber(@current_user.nickname)
      @topic.subscribers.size.should == 2
    end

    it "should remove a subscriber from a topic" do
      @topic.rm_subscriber!(@current_user.nickname)
      @topic.subscribers.size.should == 1
    end

    it "should make unread equals to posts.size when a subscriber is invited" do
      @topic.new_post(@post)
      @topic.new_post(@post)
      @topic.new_subscriber(@current_user.nickname)
      @topic.subscribers[1].unread.should == @topic.posts.size
    end

   end

  describe 'stateflow' do

    before :all do
      @topic = Factory.build(:topic)
      @post = Factory.build(:post)
      @current_user = Factory.create(:user)
      @topic.new_post(@post)
      @topic.save
    end

    it "should set delete status to a post" do
      @topic.posts[0].state.should == "published"
      @topic.posts[0].delete!
      @topic.posts[0].state.should == "deleted"
    end

    it "should set published status to a deleted post" do
      @topic.posts[0].state.should == "deleted"
      @topic.posts[0].publish!
      @topic.posts[0].state.should == "published"
    end

  end

  describe 'named_scope' do

     before :all do
      @topic = Factory.create(:topic, :creator => "One user")
      @current_user = Factory.create(:user)
    end

    it "should find by permalink" do
      Topic.by_permalink(@topic.permalink).first.permalink.should == @topic.permalink
      Topic.by_permalink("Does not exist").first.should be_nil
    end

    it "should find by subscribed topic" do
      Topic.by_subscribed_topic(@current_user.nickname).first.should_not be_nil
      Topic.by_subscribed_topic("Not a user").first.should be_nil
    end
  end

  describe "associations" do

    it "should embed many subscribers" do
      association = Topic.associations['subscribers']
      association.klass.should ==(Subscriber)
      association.association.should ==(Mongoid::Associations::EmbedsMany)
    end

    it "should embed many posts" do
      association = Topic.associations['posts']
      association.klass.should ==(Post)
      association.association.should ==(Mongoid::Associations::EmbedsMany)
    end

    it "should embed many attachments" do
      association = Topic.associations['attachments']
      association.klass.should ==(Attachment)
      association.association.should ==(Mongoid::Associations::EmbedsMany)
    end

  end
end
