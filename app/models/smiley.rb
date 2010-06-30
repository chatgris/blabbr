require 'carrierwave/orm/mongoid'

class Smiley
  include Mongoid::Document
  include Mongoid::Timestamps

  field :added_by, :type => String
  field :code, :type => String
  field :image, :type => String

  mount_uploader :image, SmileyUploader

  validates :code, :presence => true, :uniqueness => true
  validates :added_by, :presence => true

  named_scope :by_nickname, lambda { |nickname| { :where => { :added_by => nickname}}}
end
