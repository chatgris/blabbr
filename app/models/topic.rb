class Topic
  include Mongoid::Document
  include Mongoid::Timestamps
  include Stateflow

  field :creator
  field :title
  field :permalink
  field :posts_count, :type => Integer, :default => 1
  field :attachments_count, :type => Integer, :default => 0
  field :state

  embeds_many :members
  embeds_many :posts
  embeds_many :attachments

  attr_accessor :post

  stateflow do
    initial :published

    state :published, :deleted

    event :delete do
      transitions :from => :published, :to => :deleted
    end

    event :publish do
      transitions :from => :deleted, :to => :published
    end
  end

  before_validation :set_permalink
  validates :title, :presence => true, :uniqueness => true, :length => { :maximum => 100 }
  validates :permalink, :presence => true, :uniqueness => true
  validates :creator, :presence => true
  validates :post, :presence => true, :uniqueness => true, :length => { :maximum => 10000 }, :on => :create

  before_create :creator_as_members, :add_post

  named_scope :by_permalink, lambda { |permalink| { :where => { :permalink => permalink}}}
  named_scope :by_subscribed_topic, lambda { |current_user| { :where => { 'members.nickname' => current_user}}}

  def new_post(post)
    if posts.create(:body => post.body, :user_id => post.user_id)
      save
    else
      return false
    end
  end

  def update_post(post, body)
    post.body = body
    post.save
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
      if member.nickname == nickname
        return true if member.delete
        break
      end
    end
    return false
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
    user = User.by_nickname(creator).first
    posts << Post.new(:body => post, :user_id => user.id)
    user.update_attributes!(:posts_count => user.posts_count + 1)
  end

end
