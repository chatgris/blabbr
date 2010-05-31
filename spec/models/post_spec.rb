require 'spec_helper'

describe Post do

  it { Post.fields.keys.should be_include('content')}
  it { Post.fields['content'].type.should == String}

  it { Post.fields.keys.should be_include('user_id')}
  it { Post.fields['user_id'].type.should == String}

  describe 'validation' do
    it 'should required title' do
      Factory.build(:post, :user_id => '').should_not be_valid
    end

    it 'should required permalink' do
      Factory.build(:post, :content => '').should_not be_valid
    end

    it 'should validates content.size'

  end

end
