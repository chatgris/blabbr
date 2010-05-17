require 'spec_helper'

describe Topic do

  before :all do
    @topic = Factory.create(:topic)
    @post = Factory.build(:post)
    @current_user = Factory.create(:user)
    @member = Factory.build(:member)
  end

  it { Topic.fields.keys.should be_include('creator')}
  it { Topic.fields['creator'].type.should == String}

  it { Topic.fields.keys.should be_include('title')}
  it { Topic.fields['title'].type.should == String}

  it { Topic.fields.keys.should be_include('permalink')}
  it { Topic.fields['permalink'].type.should == String}

  it { Topic.fields.keys.should be_include('posts_count')}
  it { Topic.fields['posts_count'].type.should == Integer}

  it { Topic.fields.keys.should be_include('attachments_count')}
  it { Topic.fields['attachments_count'].type.should == Integer}


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
      Topic.by_permalink(@topic.permalink).first.permalink.should == @topic.title.parameterize
    end

    it "should have creator as a member" do
      @topic.members[0].nickname.should == @topic.creator
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
      @member = Factory.build(:member)
    end

    it "should increment user.posts_count and unread post when a new post is created" do
      @topic.new_post(@post)
      User.by_nickname(@current_user.nickname).first.posts_count.should == 13
    end

    it "should increment topic.posts_count when a new post is created" do
      @topic.new_post(@post)
      Topic.by_permalink(@topic.permalink).first.posts_count.should == 3
    end

  end

  describe 'members' do

    before :all do
      @topic = Factory.create(:topic)
      @post = Factory.build(:post)
      @current_user = Factory.create(:user)
      @member = Factory.build(:member)
    end

    it "shouldn't add a unregistered user to topic" do
      Topic.by_permalink(@topic.permalink).first.members.size.should == 1
      @topic.new_member(@member.nickname)
      Topic.by_permalink(@topic.permalink).first.members.size.should == 1
    end

    it "should add a registered user to topic" do
      Topic.by_permalink(@topic.permalink).first.members.size.should == 1
      @topic.new_member(@current_user.nickname)
      Topic.by_permalink(@topic.permalink).first.members.size.should == 2
    end

    it "shouldn't add a user if this user is already invited" do
      @topic.new_member(@current_user.nickname)
      Topic.by_permalink(@topic.permalink).first.members.size.should == 2
    end

    it "should make unread equals to posts.size when a member is invited" do
      @topic.new_post(@post)
      Topic.by_permalink(@topic.permalink).first.members[1].unread.should == @topic.posts.size
    end

     it "should increment unread count when a post is added" do
      Topic.by_permalink(@topic.permalink).first.members[1].unread.should == 2
      @topic.new_post(@post)
      Topic.by_permalink(@topic.permalink).first.members[1].unread.should == 3
    end

    it "should reset unread post" do
      @topic.reset_unread(@current_user.nickname)
      Topic.by_permalink(@topic.permalink).first.members[1].unread.should == 0
      Topic.by_permalink(@topic.permalink).first.members[0].unread.should_not == 0
    end

    it "should add topic_id to member" do
      @topic.new_post(@post)
      Topic.by_permalink(@topic.permalink).first.members[1].post_id.should == Topic.by_permalink(@topic.permalink).first.posts[3].id
    end

    it "should add page number of the newly added post to member" do
      Topic.by_permalink(@topic.permalink).first.members[1].page.should == @topic.posts.size / PER_PAGE + 1
    end

    it "should remove a member from a topic" do
      @topic.rm_member!(@current_user.nickname)
      Topic.by_permalink(@topic.permalink).first.members.size.should == 1
    end

  end

  describe 'attachments' do

    before :all do
      @topic = Factory.create(:topic)
      @current_user = Factory.create(:user)
    end

    it "should update attachments_count when a attachment is added or deleted" do
      @topic.new_attachment(@current_user.nickname, File.open(Rails.root.join("image.jpg")))
      Topic.where(:permalink => @topic.permalink).first.attachments_count.should == 1
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
      Topic.by_permalink(@topic.permalink).first.posts[0].state.should == "deleted"
    end

    it "should set published status to a deleted post" do
      @topic.posts[0].state.should == "deleted"
      @topic.posts[0].publish!
      Topic.by_permalink(@topic.permalink).first.posts[0].state.should == "published"
    end

  end

  describe 'named_scope' do

     before :all do
      @current_user = Factory.create(:user)
      @topic = Factory.create(:topic, :creator => "One user")
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

    it "should embed many members" do
      association = Topic.associations['members']
      association.klass.should ==(Member)
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
