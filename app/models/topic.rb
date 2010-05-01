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
  validates_presence_of :title, :permalink, :creator, :post

  before_save :update_count
  before_create :creator_as_subscribers, :add_post

  def new_post(post)
    self.posts.create(:content => post.content, :nickname => post.nickname)
    self.save
  end

  def new_subscriber(subscriber)
    if User.by_nickname(subscriber).first
      self.subscribers.create(:nickname => subscriber)
      self.save
    end
  end

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
