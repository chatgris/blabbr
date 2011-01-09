class Topic
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Stateflow

  field :creator, :type => String
  field :title, :type => String
  field :posts_count, :type => Integer, :default => 1
  field :attachments_count, :type => Integer, :default => 0
  field :state, :type => String
  field :posted_at, :type => Time, :default => Time.now.utc

  embeds_many :members
  embeds_many :attachments
  references_many :posts

  slug_field :title

  index :posted_at
  index :created_at
  index 'members.nickname'

  attr_accessor :post, :user

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

  validates :title, :presence => true, :uniqueness => true, :length => { :maximum => 100 }
  validates :user, :presence => true, :on => :create
  validates :post, :presence => true, :uniqueness => true, :length => { :maximum => 10000 }, :if => "self.new_record?"

  before_create :creator_as_members, :set_creator
  after_create :add_post

  named_scope :by_subscribed_topic, lambda { |current_user| { :where => { 'members.nickname' => current_user}}}

  def update_post(post, body)
    post.body = body
    post.save
  end

  def new_member(nickname)
    if User.by_nickname(nickname).first
      members.create(:nickname => nickname, :unread => self.posts_count)
    end
  end

  def new_attachment(nickname, attachment)
    attachments.create(:nickname => nickname, :attachment => attachment)
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
    member = members.where(:nickname => nickname).first
    unless member.unread == 0
      member.unread = 0
      member.save
    end
  end

  protected

  def set_creator
    self.creator = self.user.nickname unless self.user == ''
  end

  def creator_as_members
    self.members << Member.new(:nickname => self.user.nickname, :posts_count => 1)
  end

  def add_post
    post = Post.new(:body => self.post, :content => self.post, :creator => self.user, :new_topic => true)
    post.topic = self
    post.save
  end

end
