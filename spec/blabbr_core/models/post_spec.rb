# encoding: utf-8
require 'spec_helper'

describe BlabbrCore::Post do
  let(:post) { Factory :post }

  describe 'Fields' do
    it { should have_fields(:body) }
  end

  describe 'Relations' do
    it { should belong_to(:topic) }
    it { should belong_to(:author).with_foreign_key(:author_id) }
  end

  describe 'validations' do
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:topic) }
    it { should validate_length_of(:body).within(0..10000) }

    it 'should have a valid factory' do
      post.should be_valid
    end
  end

end
