class Topic
  include Mongoid::Document
  include Mongoid::Timestamps

  field :creator
  field :title
  field :permalink
  field :posts_count, :type => Integer, :default => 1
  field :attachments_count, :type => Integer, :default => 0

  embeds_many :members
  embeds_many :posts
  embeds_many :attachments

  attr_accessor :post

  before_validate :set_permalink
  validates_uniqueness_of :title, :permalink
  validates_presence_of :title, :permalink, :creator

  before_create :creator_as_members, :add_post

  named_scope :by_permalink, lambda { |permalink| { :where => { :permalink => permalink}}}
  named_scope :by_subscribed_topic, lambda { |current_user| { :where => { 'members.nickname' => current_user}}}

  def new_post(post)
    posts.create(:content => post.content, :user_id => post.user_id)
    save
  end

  def new_member(nickname)
    if User.by_nickname(nickname).first
      members.create(:nickname => nickname, :unread => self.posts.size) unless Topic.by_permalink(self.permalink).by_subscribed_topic(nickname).first
      save
    end
  end

  def new_attachment(nickname, attachment)
    attachments.create(:nickname => nickname, :attachment => attachment)
    save
  end

  def rm_member!(nickname)
    members.each do |member|
      member.delete if member.nickname == nickname
    end
  end

  def reset_unread(nickname)
    members.each do |s|
      s.unread = 0 if s.nickname == nickname
      Rails.logger.info s.nickname
    end
    save
  end

  protected

  def set_permalink
    self.permalink = title.parameterize.to_s unless title.nil?
  end

  def update_count
    self.posts_count = posts.size
    self.attachments_count = attachments.size
  end

  def creator_as_members
    members << Member.new(:nickname => creator, :page => members.size, :posts_count => 1)
  end

  def add_post
    posts << Post.new(:content => post, :user_id => User.by_nickname(creator).first.id)
  end

end
