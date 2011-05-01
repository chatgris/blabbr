require 'carrierwave/orm/mongoid'

class Smiley
  include Mongoid::Document
  include Mongoid::Timestamps

  field :added_by, :type => String
  field :code, :type => String

  after_save :build_cache

  mount_uploader :image, ::SmileyUploader

  validates :image, :presence => true
  validates :code, :presence => true, :uniqueness => true
  validates :added_by, :presence => true

  scope :by_nickname, ->(nickname) { where(:added_by => nickname)}

  def as_json(options={})
    super(:only => [:added_by, :code, :updated_at],
          :methods => [:path])
  end

  def path
    self.image.url
  end

  private

  def build_cache
    Rails.cache.write('smilies_list', Smiley.all.flatten.to_json)
  end
end
