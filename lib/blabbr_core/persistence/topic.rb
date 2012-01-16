# encoding: utf-8
module BlabbrCore
  module Persistence
    class Topic
      include Mongoid::Document
      include Mongoid::Timestamps
      include BlabbrCore::Limace

      # Fields
      #
      field :title, type: String

      # Relations
      #
      belongs_to  :author,  class_name: 'BlabbrCore::Persistence::User'
      embeds_many :members, class_name: 'BlabbrCore::Persistence::Member'
      has_many    :posts,   class_name: 'BlabbrCore::Persistence::Post'

      # Validations
      #
      validates :title, presence: true, uniqueness: true, length: { in: 8..42 }
      validates :author, presence: true

      # Callbacks
      #
      before_create :add_author_in_members

      # Limace
      #
      limace :title

      # Scopes
      #
      scope :with_member, lambda {|member| where('members.user_id' => member.id)}

      private

      def add_author_in_members
        self.members.build(user: self.author)
      end
    end
  end
end
