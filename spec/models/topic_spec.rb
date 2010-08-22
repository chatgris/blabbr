require 'spec_helper'

describe Topic do

  context "Fields" do
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

    it { Topic.fields.keys.should be_include('state')}
    it { Topic.fields['state'].type.should == String}

    it { Topic.fields.keys.should be_include('posted_at')}
    it { Topic.fields['posted_at'].type.should == Time}
  end

  context "Validations" do
    it "should be valid" do
      @creator = Factory.create(:creator)
      @topic = Factory.create(:topic)
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

      it 'should validates title.size' do
        Factory.build(:topic, :title => (0...101).map{65.+(rand(25)).chr}.join).should_not be_valid
      end
    end

    describe 'validation with context' do

      before :each do
        @creator = Factory.create(:creator)
        @topic = Factory.create(:topic)
        @post = Factory.build(:post)
      end

      it 'should not valid if title is already taken' do
        Factory.build(:topic).should_not be_valid
      end

      it 'should not valid if permalink is already taken' do
        Factory.build(:topic, :permalink => 'permalink').should_not be_valid
      end

      it 'should have a valid posted_add time' do
        @topic.reload.posted_at.should be_close(Time.now.utc, 10.seconds)
      end

      it "should have a valid permalink" do
        @topic.reload.permalink.should == @topic.title.parameterize
      end

      it "should have creator as a member" do
        @topic.members[0].nickname.should == @topic.creator
      end

      it "should have a post" do
        @topic.reload.posts.first.body.should == @post.body
      end
    end
  end

  #describe 'members' do

    #before :each do
      #@creator  = Factory.create(:creator )
      #@topic = Factory.create(:topic)
      #@current_user = Factory.create(:user)
      #@post = Factory.build(:post, :user_id => @current_user.id)
      #@member = Factory.build(:member)
    #end

    #context " Adding new members "do
      #it "shouldn't add a unregistered user to topic" do
        #Topic.by_permalink(@topic.permalink).first.members.size.should == 1
        #@topic.new_member(@member.nickname)
        #Topic.by_permalink(@topic.permalink).first.members.size.should == 1
      #end

      #it "should add a registered user to topic" do
        #Topic.by_permalink(@topic.permalink).first.members.size.should == 1
        #@topic.new_member(@current_user.nickname)
        #Topic.by_permalink(@topic.permalink).first.members.size.should == 2
      #end

      #it "should have a posts_count equals to 0 when invited" do
        #@topic.new_member(@current_user.nickname)
        #Topic.by_permalink(@topic.permalink).first.members[1].posts_count.should == 0
      #end

      #it "shouldn't add a user if this user is already invited" do
        #@topic.new_member(@current_user.nickname)
        #Topic.by_permalink(@topic.permalink).first.members.size.should == 2
      #end

      #it "should make unread equals to posts.size when a member is invited" do
        #@topic.new_member(@current_user.nickname)
        #Topic.by_permalink(@topic.permalink).first.members[1].unread.should == Topic.by_permalink(@topic.permalink).first.posts.size
      #end
    #end

    #context "Adding a new post" do
      #it "should have increment posts_count when a new post is added by user" do
        #@topic.new_member(@current_user.nickname)
        #Topic.by_permalink(@topic.permalink).first.members[1].posts_count.should == 0
        #@topic.new_post(@post)
        #Topic.by_permalink(@topic.permalink).first.members[1].posts_count.should == 1
      #end

      #it "shouldn't increment posts_count of creator in this context" do
        #Topic.by_permalink(@topic.permalink).first.members[0].posts_count.should == 1
      #end

      #it "shouldn't add a post if body is not present" do
        #Topic.by_permalink(@topic.permalink).first.posts.size.should == 1
        #@post = Factory.build(:post, :user_id => @current_user.id, :body => "")
        #@topic.new_post(@post)
        #Topic.by_permalink(@topic.permalink).first.posts.size.should == 1
      #end

      #it "should increment unread count when a post is added" do
        #@topic.new_member(@current_user.nickname)
        #Topic.by_permalink(@topic.permalink).first.members[1].unread.should == 1
        #@topic.new_post(@post)
        #Topic.by_permalink(@topic.permalink).first.members[1].unread.should == 2
      #end

      #it "should reset unread post" do
        #@topic.new_member(@current_user.nickname)
        #@topic.reset_unread(@current_user.nickname)
        #Topic.by_permalink(@topic.permalink).first.members[1].unread.should == 0
        #@topic.new_post(@post)
        #Topic.by_permalink(@topic.permalink).first.members[0].unread.should_not == 0
      #end

      #it "should add post_id to member" do
        #@topic.new_member(@current_user.nickname)
        #@topic.new_post(@post)
        #Topic.by_permalink(@topic.permalink).first.members[0].post_id.should == Topic.by_permalink(@topic.permalink).first.posts[1].id.to_s
      #end

      #it "should add page number of the newly added post to member" do
        #@topic.new_member(@current_user.nickname)
        #Topic.by_permalink(@topic.permalink).first.members[1].page.should == @topic.posts.size / PER_PAGE + 1
      #end
    #end

    #context "Removing a member" do
      #it "should remove a member from a topic" do
        #@topic.new_member(@current_user.nickname)
        #@topic.rm_member!(@current_user.nickname)
        #Topic.by_permalink(@topic.permalink).first.members.size.should == 1
      #end
    #end
  #end

  describe 'attachments' do

    before :each do
      @creator  = Factory.create(:creator)
      @topic = Factory.create(:topic)
      @current_user = Factory.create(:user)
    end

    context "Default status" do
      it "should have a member.attachments_count equals to 0" do
        Topic.by_permalink(@topic.permalink).first.members[0].attachments_count.should == 0
      end
    end

    context "Topic related callbacks" do
      it "should increment member.attachments_count when a new attachment is added" do
        @topic.new_attachment(@creator.nickname, File.open(Rails.root.join("image.jpg")))
        Topic.by_permalink(@topic.permalink).first.members[0].attachments_count.should == 1
      end

      it "should update attachments_count when a attachment is added or deleted" do
        @topic.new_attachment(@current_user.nickname, File.open(Rails.root.join("image.jpg")))
        Topic.where(:permalink => @topic.permalink).first.attachments_count.should == 1
      end
    end

  end

  describe 'stateflow' do

    before :each do
      @current_user = Factory.create(:creator )
      @topic = Factory.create(:topic)
    end

    context "By default" do
      it "should be set to published by default" do
        Topic.by_permalink(@topic.permalink).first.state.should == "published"
      end

      it "should set a topic as deleted" do
        @topic.delete!
        Topic.by_permalink(@topic.permalink).first.state.should == "deleted"
      end
    end

    context "When a Topic is set to deleted" do
      before :each do
        @topic.delete!
      end

      it "should set a deleted topic as published" do
        @topic.publish!
        Topic.by_permalink(@topic.permalink).first.state.should == "published"
      end
    end

  end

  #describe 'stateflow for embeddeded posts' do

    #before :each do
      #@topic = Factory.build(:topic)
      #@current_user = Factory.create(:user)
      #@post = Factory.build(:post, :user_id => @current_user.id)
      #@creator  = Factory.create(:creator )
      #@topic.new_post(@post)
      #@topic.save
    #end

    #context "Default state" do
      #it "a post should be published by default" do
        #@topic.posts[0].state.should == "published"
      #end

      #it "should set delete status to a post" do
        #@topic.posts[0].delete!
        #Topic.by_permalink(@topic.permalink).first.posts[0].state.should == "deleted"
      #end
    #end

    #context "When a post is deleted" do
      #before(:each) do
        #@topic.posts[0].delete!
      #end

      #it "should set published status to a deleted post" do
        #@topic.posts[0].publish!
        #Topic.by_permalink(@topic.permalink).first.posts[0].state.should == "published"
      #end
    #end

  #end

  describe 'named_scope' do

     before :each do
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

  #describe 'updating a post' do
    #before :each do
      #@creator  = Factory.create(:creator )
      #@topic = Factory.create(:topic)
      #@current_user = Factory.create(:user)
      #@post = Factory.build(:post, :user_id => @current_user.id)
      #@topic.new_post(@post)
    #end

    #it "should update a post" do
      #post = Topic.by_permalink(@topic.permalink).first.posts[1]
      #@topic.update_post(post, "This post was edited")
      #Topic.by_permalink(@topic.permalink).first.posts[1].body.should == "This post was edited"
    #end

  #end

  describe "associations" do

    it "should embed many members" do
      association = Topic.associations['members']
      association.klass.should ==(Member)
      association.association.should ==(Mongoid::Associations::EmbedsMany)
    end

    it "should embed many attachments" do
      association = Topic.associations['attachments']
      association.klass.should ==(Attachment)
      association.association.should ==(Mongoid::Associations::EmbedsMany)
    end

    it "should embed many posts" do
      association = Topic.associations['posts']
      association.klass.should ==(Post)
      association.association.should ==(Mongoid::Associations::ReferencesMany)
    end

  end
end
