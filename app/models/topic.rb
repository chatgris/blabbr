class Topic
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Stateflow
  include Rails.application.routes.url_helpers

  field :creator, :type => String
  field :title, :type => String
  field :posts_count, :type => Integer, :default => 1
  field :attachments_count, :type => Integer, :default => 0
  field :state, :type => String
  field :last_user, :type => String
  field :posted_at, :type => Time, :default => Time.now.utc

  embeds_many :members
  embeds_many :attachments
  references_many :posts, :validate => false, autosave: true

  accepts_nested_attributes_for :posts
  attr_accessor :user

  slug_field :title

  index :posted_at
  index :created_at
  index 'members.nickname'

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
  validates :posts, :presence => true

  before_create :set_attributes

  scope :by_subscribed_topic, ->(current_user) {where('members.nickname' => current_user)}
  scope :for_creator,         ->(creator) { where('creator' => creator)}

  def add_member(nickname)
    if User.by_nickname(nickname).first
      members.create(:nickname => nickname, :unread => self.posts_count)
    end
  end

  def new_attachment(nickname, attachment)
    attachments.create(:nickname => nickname, :attachment => attachment)
  end

  def rm_member!(nickname)
    members.where(nickname: nickname).delete
  end

  def reset_unread(nickname)
    member = members.where(:nickname => nickname).first
    unless member.unread == 0
      member.unread = 0
      member.save
    end
  end

  def as_json(options={})
    super(:only => [:creator, :members, :title, :posts_count, :last_user, :posted_at, :created_at],
          :methods => :path)
  end

  protected

  def path
    topic_path(self)
  end

  def set_attributes
    self.creator = self.user.nickname unless self.user == ''
    self.members << Member.new(:nickname => self.user.nickname, :posts_count => 1)
    self.last_user = self.user.nickname
    self.posts.first.tap do |post|
      post.creator = self.user
      post.new_topic = true
    end
  end

end
