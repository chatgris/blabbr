# encoding: utf-8
module BlabbrCore
  class PostObserver < Mongoid::Observer
    observe BlabbrCore::Post

    def after_create(resource)
      resource.author.inc(:posts_count, 1)
    end
  end
end
