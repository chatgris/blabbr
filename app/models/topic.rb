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

  validates :title, :presence => true, :uniqueness => true, :length => { :maximum => 100 }
  validates :creator, :presence => true
  validates :post, :presence => true, :uniqueness => true, :length => { :maximum => 10000 }, :if => "self.new_record?"

  before_create :creator_as_members
  after_validation :add_post, :if => "self.new_record?"

  named_scope :by_subscribed_topic, lambda { |current_user| { :where => { 'members.nickname' => current_user}}}

  def update_post(post, body)
    post.body = body
    post.save
  end

  def new_member(nickname)
    if User.by_nickname(nickname).first
      members.create(:nickname => nickname, :unread => self.posts_count)
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
    member = members.where(:nickname => nickname).first
    unless member.unread == 0
      member.unread = 0
      save
    end
  end

  protected

  def creator_as_members
    self.members << Member.new(:nickname => self.creator, :posts_count => 1)
  end

  def add_post
    self.posts << Post.create(:body => self.post, :content => self.post, :user_id => User.by_nickname(creator).first.id, :topic_id => self.id, :new_topic => true)
  end

end
