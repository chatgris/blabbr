# encoding: utf-8
require 'spec_helper'

describe BlabbrCore::Topic do
  describe 'Fields' do
    it { should have_fields(:title) }
  end

  describe 'Relations' do
    it { should belong_to(:author).of_type(BlabbrCore::User) }
    it { should embed_many(:members) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:author) }
    it { should validate_length_of(:title).within(8..42) }

    it 'should have a valid factory' do
      Factory(:topic).should be_valid
    end
  end
end
