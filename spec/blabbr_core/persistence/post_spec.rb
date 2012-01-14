# encoding: utf-8
require 'spec_helper'

describe BlabbrCore::Persistence::Post do
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

  describe 'state_machine' do
    describe 'intial state' do
      it 'should be published be default' do
        post.should be_published
      end
    end

    describe 'unpublish' do
      it 'should unpublish a post' do
        post.unpublish.should be_true
        post.reload.should be_unpublished
        post.reload.should_not be_published
      end
    end

    describe 'publish' do
      before { post.unpublish }

      it 'should publish a post' do
        post.should be_unpublished
        post.publish.should be_true
        post.should be_published
      end
    end
  end

end
