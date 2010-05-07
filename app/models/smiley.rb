class Smiley
  include Mongoid::Document
  include Mongoid::Timestamps

  field :added_by, :type => String
  field :code, :type => String

  validates_presence_of :code, :added_by
  validates_uniqueness_of :code
end
