# encoding: utf-8
module BlabbrCore
  class User
    include Mongoid::Document
    include Mongoid::Timestamps::Created

    # Fields
    #
    field :email,       type: String
    field :nickname,    type: String
    field :posts_count, type: Integer, default: 0

    # Relations
    #
    has_many :topics, class_name: 'BlabbrCore::Topic'

    # Validations
    #
    validates :email,    presence: true, uniqueness: true
    validates :nickname, presence: true, uniqueness: true, length: { in: 8..42 }

  end
end
