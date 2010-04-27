require 'spec_helper'

describe Topic do

  before :all do
    @topic = Factory.build(:topic)
    @topic.save
    @post = Factory.build(:post)

  end

  it "should be valid" do
    @topic.should be_valid
  end

  it "should have a valid permalink" do
    @topic.permalink.should == @topic.title.parameterize
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

    it "should increment topic.posts_count when a new post is created" do
      @topic.posts_count.should == 0
      @topic.posts << @post
      @topic.save
      @topic.posts_count.should == 1
    end


    it "should decrement topic.posts_count when a new post is deleted" do
      @topic.posts_count.should == 1
      @topic.posts.delete_if { |post| post.content == "Some content" }
      @topic.save
      @topic.posts_count.should == 0
    end

    it "shloud increment user.posts_count when a new post is created" do
      @user = User.new(:nickname => "chatgris", :email => "mail@mail.com", :permalink => "chatgris", :locale => "fr", :posts_count => 12, :identity_url => "http://myopenid.com")
      @user.save
      @topic.posts.create(:content => "test", :nickname => @user.nickname)
      @user.posts_count.should == 13
    end
  end
end
