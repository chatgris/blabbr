class Topic
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Stateflow

  field :creator
  field :title
  field :posts_count, :type => Integer, :default => 1
  field :attachments_count, :type => Integer, :default => 0
  field :state
  field :posted_at, :type => Time

  embeds_many :members
  embeds_many :attachments
  references_many :posts

  slug_field :title

  index :posted_at
  index :created_at

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

  after_validation :creator_as_members, :set_posted_at, :add_post

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
    members.where(:nickname => nickname).first.unread = 0
    save
  end

  protected

  def creator_as_members
    if self.new_record? && members.empty?
      members << Member.new(:nickname => creator, :posts_count => 1)
    end
  end

  def add_post
    user = User.by_nickname(creator).first
    self.posts = [Post.create(:body => post, :user_id => user.id)]
  end

  def set_posted_at
    if self.new_record?
      self.posted_at = Time.now.utc
    end
  end

end
