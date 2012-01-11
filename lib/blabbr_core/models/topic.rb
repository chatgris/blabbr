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
    belongs_to  :author,  class_name: 'BlabbrCore::User'
    embeds_many :members, class_name: 'BlabbrCore::Member'

    # Validations
    #
    validates :title, presence: true, uniqueness: true, length: { in: 8..42 }
    validates :author, presence: true

    # Callbacks
    #
    before_create :add_author_in_members

    private

    def add_author_in_members
      self.members.build(user: self.author)
    end
  end
end
