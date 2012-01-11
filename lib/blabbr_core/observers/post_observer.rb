# encoding: utf-8
module BlabbrCore
  class PostObserver < Mongoid::Observer
    observe BlabbrCore::Post

    def after_create(resource)
      inc_user_posts_count(resource)
      inc_member_posts_count(resource)
    end

    private

    def inc_user_posts_count(resource)
      resource.author.inc(:posts_count, 1)
    end

    def inc_member_posts_count(resource)
      resource.topic.members.where(user_id: resource.author.id.to_s).one.inc(:posts_count, 1)
    end
  end
end
