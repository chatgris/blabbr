# encoding: utf-8
module BlabbrCore
  class Member
    include Mongoid::Document
    include Mongoid::Timestamps

    # Fields
    #
    field :unread,      type: Integer, default: 0
    field :posts_count, type: Integer, default: 0

    # Relations
    #
    belongs_to  :user,    class_name: 'BlabbrCore::User'
    embedded_in :topic,   class_name: 'BlabbrCore::Topic'
  end
end
