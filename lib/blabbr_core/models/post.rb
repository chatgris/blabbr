# encoding: utf-8
module BlabbrCore
  class Post
    include Mongoid::Document
    include Mongoid::Timestamps

    # Fields
    #
    field :body, type: String

    # Relations
    #
    belongs_to :topic,  class_name: 'BlabbrCore::Topic'
    belongs_to :author, class_name: 'BlabbrCore::User'

    # Validations
    #
    validates :body, presence: true, uniqueness: true, length: { in: 0..10000 }
    validates :author, presence: true
    validates :topic, presence: true
  end
end
