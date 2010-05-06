require 'spec_helper'

describe Post do

  it { Post.fields.keys.should be_include('content')}
  it { Post.fields['content'].type.should == String}

  it { Post.fields.keys.should be_include('nickname')}
  it { Post.fields['nickname'].type.should == String}

  describe 'validation' do
    it 'should required title' do
      Factory.build(:post, :nickname => '').should_not be_valid
    end

    it 'should required permalink' do
      Factory.build(:post, :content => '').should_not be_valid
    end
  end

end
