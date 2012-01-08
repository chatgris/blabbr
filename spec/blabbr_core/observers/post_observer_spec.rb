# encoding: utf-8
require 'spec_helper'

describe BlabbrCore::PostObserver do
  let(:post) { Factory :post }

  describe 'after_create observer' do
    before { post }

    it 'should increment user posts_count' do
      post.author.posts_count.should eq 1
    end
  end

end
