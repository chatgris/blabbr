require 'spec_helper'

describe Post do

  it { Post.fields.keys.should be_include('body')}
  it { Post.fields['body'].type.should == String}

  it { Post.fields.keys.should be_include('user_id')}
  it { Post.fields['user_id'].type.should == BSON::ObjectID}

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

end
