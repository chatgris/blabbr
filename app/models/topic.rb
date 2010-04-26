class Topic
  include Mongoid::Document
  include Mongoid::Timestamps

  field :creator, :type => String
  field :title, :type => String
  field :permalink, :type => String
  field :posts_count, :type => Integer, :default => 1

  embeds_many :subscribers
  embeds_many :posts

  attr_accessor :post

  validates_uniqueness_of :title, :permalink
  validates_presence_of :title, :permalink, :creator
  before_validate :set_permalink

  protected

  def set_permalink
    self.permalink = title.parameterize.to_s unless title.nil?
  end

end
