require 'spec_helper'

describe Topic do

  before :all do
    @topic = Factory.build(:topic)
    @topic.save
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

end
