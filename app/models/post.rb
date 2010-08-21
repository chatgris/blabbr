class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Stateflow

  field :body
  field :state

  embedded_in :topics, :inverse_of => :posts, :index => true
  referenced_in :user

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

  validates :body, :presence => true, :length => {:maximum => 10000}
  validates :user_id, :presence => true

  before_create :set_unread, :update_user_posts_count, :update_posted_at

  protected

  def update_user_posts_count
    User.find(user_id).update_attributes!(:posts_count => user.posts_count + 1)
  end

  def update_posted_at
    self.topics.posted_at = Time.now.utc
  end

  def set_unread
    self.topics.members.each do |member|
      if member.unread == 0
        member.post_id = self.id
        member.page = self.topics.posts_count / PER_PAGE + 1
      end
      if member.nickname == self.user.nickname
        member.posts_count += 1
      end
      member.unread += 1
    end
  end

end
