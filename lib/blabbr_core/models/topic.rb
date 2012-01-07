# encoding: utf-8
module BlabbrCore
  class Topic
    include Mongoid::Document
    include Mongoid::Timestamps

    # Fields
    #
    field :title, type: String

    # Relations
    #
    belongs_to :author, class_name: 'BlabbrCore::User'

    # Validations
    #
    validates :title, presence: true, uniqueness: true, length: { in: 8..42 }
    validates :author, presence: true
  end
end
