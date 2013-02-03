# encoding: utf-8
require 'spec_helper'

describe Smiley do

  describe 'fields' do
    it { should have_fields(:added_by, :code).of_type(String) }
    it { should have_fields(:width, :height).of_type(Integer) }
  end

  describe 'validation' do
    it { should validate_presence_of(:image) }
    it { should validate_presence_of(:code) }
    it { should validate_presence_of(:added_by) }
    it { should validate_uniqueness_of(:code) }
  end

  describe 'named_scope' do

    before :each do
      @smiley = Factory.create(:smiley)
    end

    it "should be find by added_by" do
      Smiley.by_nickname(@smiley.added_by).first.added_by.should == @smiley.added_by
    end

  end
end
