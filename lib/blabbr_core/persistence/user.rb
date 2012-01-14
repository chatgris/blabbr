# encoding: utf-8
module BlabbrCore
  module Persistence
    class User
      include Mongoid::Document
      include Mongoid::Timestamps::Created
      include Mongoid::Fromage
      include BlabbrCore::Limace

      # Fields
      #
      field :email,       type: String
      field :nickname,    type: String
      field :posts_count, type: Integer, default: 0

      # Relations
      #
      has_many :topics, class_name: 'BlabbrCore::Persistence::Topic'

      # Validations
      #
      validates :email,    presence: true, uniqueness: true
      validates :nickname, presence: true, uniqueness: true, length: { in: 8..42 }

      # Limace
      #
      limace :nickname

      # Roles
      #
      fromages :admin
    end
  end
end
