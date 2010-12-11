require 'spec_helper'

describe Topic do

  context "Fields" do
    it { Topic.fields.keys.should be_include('creator')}
    it { Topic.fields['creator'].type.should == String}

    it { Topic.fields.keys.should be_include('title')}
    it { Topic.fields['title'].type.should == String}

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
      @creator = Factory.build(:creator)
      @creator.save!
      @topic = Factory.create(:topic)
      @topic.should be_valid
    end

    describe 'validation' do

      it 'should required title' do
        Factory.build(:topic, :title => '').should_not be_valid
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

      it "should have a valid slug" do
        @topic.reload.slug.should == @topic.title.parameterize
      end

      it 'should not valid if title is already taken' do
        Factory.build(:topic).should_not be_valid
      end


      it 'should have a valid posted_add time' do
        @topic.reload.posted_at.should be_within(Time.now.to_i - 10).of(Time.now.utc + 10)
      end

      it "should have creator as a member" do
        @topic.members[0].nickname.should == @topic.creator
      end

      it "should have a post" do
        @topic.reload.posts.first.body.should == @post.body
      end
    end
  end

  describe 'members' do

    before :each do
      @creator  = Factory.create(:creator )
      @topic = Factory.create(:topic)
      @current_user = Factory.create(:user)
      @post = Factory.build(:post, :user_id => @current_user.id)
      @member = Factory.build(:member)
    end

    context " Adding new members "do
      it "should have one member" do
        @topic.reload.members.size.should == 1
      end

      it "shouldn't add a unregistered user to topic" do
        @topic.reload.members.size.should == 1
        @topic.new_member(@member.nickname)
        @topic.reload.members.size.should == 1
      end

      it "should add a registered user to topic" do
        @topic.new_member(@current_user.nickname)
        @topic.reload.members.size.should == 2
      end

      it "should have a posts_count equals to 0 when invited" do
        @topic.new_member(@current_user.nickname)
        @topic.reload.members[1].posts_count.should == 0
      end

      it "shouldn't add a user if this user is already invited" do
        @topic.new_member(@current_user.nickname)
        @topic.reload.members.size.should == 2
      end

      it "should make unread equals to posts.size when a member is invited" do
        @topic.new_member(@current_user.nickname)
        @topic.reload.members[1].unread.should == @topic.reload.posts.size
      end
    end
    end

  describe 'attachments' do

    before :each do
      @creator  = Factory.create(:creator)
      @topic = Factory.create(:topic)
      @current_user = Factory.create(:user)
    end

    context "Default status" do
      it "should have a member.attachments_count equals to 0" do
        @topic.reload.members[0].attachments_count.should == 0
      end
    end

    context "Topic related callbacks" do
      it "should increment member.attachments_count when a new attachment is added" do
        @topic.new_attachment(@creator.nickname, File.open(Rails.root.join("image.jpg")))
        @topic.reload.members[0].attachments_count.should == 1
      end

      it "should update attachments_count when a attachment is added or deleted" do
        @topic.new_attachment(@current_user.nickname, File.open(Rails.root.join("image.jpg")))
        @topic.reload.attachments_count.should == 1
      end
    end

  end

  describe 'stateflow' do

    before :each do
      @current_user = Factory.create(:creator)
      @topic = Factory.create(:topic)
    end

    context "By default" do
      it "should be set to published by default" do
        @topic.reload.state.should == "published"
      end

      it "should set a topic as deleted" do
        @topic.delete!
        @topic.reload.state.should == "deleted"
      end
    end

    context "When a Topic is set to deleted" do
      before :each do
        @topic.delete!
      end

      it "should set a deleted topic as published" do
        @topic.publish!
        @topic.reload.state.should == "published"
      end
    end

  end

  describe 'named_scope' do

     before :each do
      @current_user = Factory.create(:user)
      @topic = Factory.create(:topic, :creator => "One user")
    end

    it "should find by slug" do
      Topic.by_slug(@topic.reload.slug).first.title.should == @topic.title
      Topic.by_slug("Does not exist").first.should be_nil
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
