require 'spec_helper'

describe Subscriber do

  it { Subscriber.fields.keys.should be_include('nickname')}
  it { Subscriber.fields['nickname'].type.should == String}
  it { Subscriber.fields.keys.should be_include('unread')}
  it { Subscriber.fields['unread'].type.should == Integer}
  it { Subscriber.fields.keys.should be_include('page')}
  it { Subscriber.fields['page'].type.should == Integer}
  it { Subscriber.fields.keys.should be_include('post_id')}
  it { Subscriber.fields['post_id'].type.should == String}

  describe 'validation' do
    it 'should required title' do
      Factory.build(:subscriber, :nickname => '').should_not be_valid
    end
  end

end
