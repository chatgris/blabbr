# encoding: utf-8
require 'carrierwave/orm/mongoid'

class Smiley
  include Mongoid::Document
  include Mongoid::Timestamps

  field :added_by, :type => String
  field :code, :type => String
  field :width, :type => Integer
  field :height, :type => Integer

  before_save :set_dimensions
  after_save :build_cache

  mount_uploader :image, ::SmileyUploader

  validates :image, :presence => true
  validates :code, :presence => true, :uniqueness => true
  validates :added_by, :presence => true

  scope :by_nickname, ->(nickname) { where(:added_by => nickname)}

  def as_json(options={})
    super(:only => [:added_by, :code, :width, :height],
          :methods => [:path, :ts])
  end

  def path
    self.image.url
  end

  def ts
    self.updated_at.to_i.to_s
  end

  private

  def build_cache
    Rails.cache.write('smilies_list', Smiley.all.flatten.to_json)
  end

  def set_dimensions
    dimensions = self.image.get_dimensions
    self.width = dimensions[:width]
    self.height = dimensions[:height]
  end
end
