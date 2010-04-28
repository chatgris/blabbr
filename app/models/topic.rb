class Topic
  include Mongoid::Document
  include Mongoid::Timestamps

  field :creator, :type => String
  field :title, :type => String
  field :permalink, :type => String
  field :posts_count, :type => Integer, :default => 0

  embeds_many :subscribers
  embeds_many :posts

  attr_accessor :post

  before_validate :set_permalink
  validates_uniqueness_of :title, :permalink
  validates_presence_of :title, :permalink, :creator

  before_save :update_count
  before_create :creator_as_subscribers, :add_post

  protected

  def set_permalink
    self.permalink = title.parameterize.to_s unless title.nil?
  end

  def update_count
    self.posts_count = self.posts.size
  end

  def creator_as_subscribers
    self.subscribers << Subscriber.new(:nickname => creator)
  end

  def add_post
    self.posts << Post.new(:content => post, :nickname => creator)
  end

end
