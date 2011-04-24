require 'carrierwave/orm/mongoid'

class Smiley
  include Mongoid::Document
  include Mongoid::Timestamps

  field :added_by, :type => String
  field :code, :type => String

  mount_uploader :image, ::SmileyUploader

  validates :image, :presence => true
  validates :code, :presence => true, :uniqueness => true
  validates :added_by, :presence => true

  scope :by_nickname, ->(nickname) { where(:added_by => nickname)}
end
