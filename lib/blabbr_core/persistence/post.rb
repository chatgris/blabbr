# encoding: utf-8
module BlabbrCore
  module Persistence
    class Post
      include Mongoid::Document
      include Mongoid::Timestamps

      # Fields
      #
      field :body,  type: String
      field :state, type: Symbol, default: :published

      # Relations
      #
      belongs_to :topic,  class_name: 'BlabbrCore::Persistence::Topic'
      belongs_to :author, class_name: 'BlabbrCore::Persistence::User'

      # Validations
      #
      validates :body, presence: true, uniqueness: true, length: { in: 0..10000 }
      validates :author, presence: true
      validates :topic, presence: true
    end
  end
end
