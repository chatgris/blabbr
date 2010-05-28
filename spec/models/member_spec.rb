require 'spec_helper'

describe Member do

  it { Member.fields.keys.should be_include('nickname')}
  it { Member.fields['nickname'].type.should == String}
  it { Member.fields.keys.should be_include('unread')}
  it { Member.fields['unread'].type.should == Integer}
  it { Member.fields.keys.should be_include('page')}
  it { Member.fields['page'].type.should == Integer}
  it { Member.fields.keys.should be_include('post_id')}
  it { Member.fields['post_id'].type.should == String}
  it { Member.fields.keys.should be_include('posts_count')}
  it { Member.fields['posts_count'].type.should == Integer}
  it { Member.fields.keys.should be_include('attachments_count')}
  it { Member.fields['attachments_count'].type.should == Integer}

  describe 'validation' do
    it 'should required title' do
      Factory.build(:member, :nickname => '').should_not be_valid
    end
  end

end
