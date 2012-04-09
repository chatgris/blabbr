# encoding: utf-8
require 'spec_helper'

describe BlabbrCore::PostObserver do
  let(:post) { Factory :post }

  describe 'after_create observer' do

    describe 'inc_user_posts_count' do
      before { post }

      it 'should increment user posts_count' do
        post.author.posts_count.should eq 1
      end
    end


    describe 'update_topic_members' do
      before do
        topic = post.topic
        topic.members.create(user: Factory(:user))
        topic.save
        Factory(:post, author: post.author, body: 'blabla', topic: post.topic)
      end

      it 'should increment members posts_count for this topic' do
        post.topic.members.first.posts_count.should eq 2
      end

      it 'should increment members unread_count for this topic' do
        post.topic.members.last.unread_count.should eq 2
      end

      it 'should not increment other members posts_count' do
        post.topic.reload.members.last.posts_count.should eq 0
      end

      it 'should set post_id for member with 0 unread_count posts' do
        post.topic.reload.members.last.post_id.should eq post.topic.posts.first.id.to_s
      end
    end
  end

end
