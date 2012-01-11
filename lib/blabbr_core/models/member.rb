# encoding: utf-8
module BlabbrCore
  class Member
    include Mongoid::Document
    include Mongoid::Timestamps

    # Fields
    #
    field :unread,      type: Integer, default: 0
    field :posts_count, type: Integer, default: 0
    field :post_id,     type: String

    # Relations
    #
    belongs_to  :user,    class_name: 'BlabbrCore::User'
    embedded_in :topic,   class_name: 'BlabbrCore::Topic'

    # Callbacks
    #
    before_validation :set_defaults

    private

    def set_defaults
      if self.topic && self.new_record? && self.user != self.topic.author
        self.unread   = self.topic.posts.count
        self.post_id  = self.topic.posts.last.id.to_s
      end
    end
  end
end
