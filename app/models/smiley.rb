require 'carrierwave/orm/mongoid'

class Smiley
  include Mongoid::Document
  include Mongoid::Timestamps

  field :added_by, :type => String
  field :code, :type => String
  field :smiley, :type => String

  mount_uploader :smiley, SmileyUploader

  validates_presence_of :code, :added_by
  validates_uniqueness_of :code
end
