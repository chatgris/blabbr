# encoding: utf-8
module BlabbrCore
  module Persistence
    class Member
      include Mongoid::Document
      include Mongoid::Timestamps

      # Fields
      #
      field :unread_count,   type: Integer, default: 0
      field :posts_count,    type: Integer, default: 0
      field :post_id,        type: String

      # Relations
      #
      belongs_to  :user,    class_name: 'BlabbrCore::Persistence::User'
      embedded_in :topic,   class_name: 'BlabbrCore::Persistence::Topic'

      # Callbacks
      #
      before_validation :set_defaults

      def reset_unread_count
        self.unread_count = 0
      end

      def reset_unread_count!
        self.reset_unread_count
        self.save
      end

      private

      def set_defaults
        if self.topic && self.new_record? && self.user != self.topic.author
          self.unread_count   = self.topic.posts.count
          self.post_id  = self.topic.posts.last.id.to_s if self.topic.posts.last
        end
      end
    end
  end
end
