# encoding: utf-8
module BlabbrCore
  class PostObserver < Mongoid::Observer
    observe BlabbrCore::Post

    def after_create(resource)
      inc_user_posts_count(resource)
      update_topic_members(resource)
    end

    private

    def inc_user_posts_count(resource)
      resource.author.inc(:posts_count, 1)
    end

    def update_topic_members(resource)
      resource.topic.members.each do |member|
        if member.unread == 0
          member.post_id = resource.id.to_s
        end
        if member.user_id == resource.author_id
          member.posts_count += 1
        else
          member.unread += 1
        end
      end
      resource.topic.save
    end
  end
end
