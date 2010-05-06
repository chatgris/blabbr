require 'spec_helper'

describe Subscriber do

  it { Subscriber.fields.keys.should be_include('nickname')}
  it { Subscriber.fields['nickname'].type.should == String}

  describe 'validation' do
    it 'should required title' do
      Factory.build(:subscriber, :nickname => '').should_not be_valid
    end
  end

end
