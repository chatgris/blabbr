require 'spec_helper'

describe Topic do

  before :all do
    @topic = Factory.build(:topic)
    @topic.save
    @post = Factory.build(:post)
    @current_user = Factory.build(:user)
    @current_user.save
  end

  it "should be valid" do
    @topic.should be_valid
  end

  it "should have a valid permalink" do
    @topic.permalink.should == @topic.title.parameterize
  end

  it "should increment user.posts_count when a new post is created" do
    @topic.posts.create(:content => "test", :nickname => @current_user.nickname)
    @topic.save
    User.where(:nickname => @current_user.nickname).first.posts_count.should == 13
  end

  it "should increment topic.posts_count when a new post is created" do
    @topic.posts_count.should == 1
    @topic.posts << @post
    @topic.save
    @topic.posts_count.should == 2
  end


  it "should decrement topic.posts_count when a new post is deleted" do
    @topic.posts_count.should == 2
    @topic.posts.delete_if { |post| post.content == "Some content" }
    @topic.save
    @topic.posts_count.should == 1
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:permalink) }
    it { should validate_presence_of(:creator) }
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
