require 'spec_helper'

describe Smiley do
  it { Smiley.fields.keys.should be_include('added_by')}
  it { Smiley.fields['added_by'].type.should == String}

  it { Smiley.fields.keys.should be_include('code')}
  it { Smiley.fields['code'].type.should == String}

  describe 'validation' do
    it 'should be valid' do
      Factory.build(:smiley).should be_valid
    end

    it 'should required a code' do
      Factory.build(:smiley, :code => '').should_not be_valid
    end

    it 'should required a added_by' do
      Factory.build(:smiley, :added_by => '').should_not be_valid
    end

    it 'should not be valid if a code is already taken' do
      Factory.create(:smiley)
      Factory.build(:smiley).should_not be_valid
    end
  end

  describe 'named_scope' do

    before :all do
      @smiley = Factory.create(:smiley)
    end

    it "should be find by added_by" do
      Smiley.by_nickname(@smiley.added_by).first.added_by.should == @smiley.added_by
    end

  end
end
