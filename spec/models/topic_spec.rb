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

  it "should be valid" do
    @topic.should be_valid
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

  it "should increment user.posts_count and unread post when a new post is created" do
    @topic.new_post(@post)
    @topic.save
    User.where(:nickname => @current_user.nickname).first.posts_count.should == 13
    @topic.subscribers[0].unread.should == 2
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

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:permalink) }
    it { should validate_presence_of(:creator) }
    it { should validate_presence_of(:post) }
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


  end
end
