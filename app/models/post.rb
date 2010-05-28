class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Stateflow

  field :user_id
  field :content
  field :state

  embedded_in :topics, :inverse_of => :posts
  belongs_to_related :user

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

  validates_presence_of :content, :user_id

  before_create :set_unread, :update_topic_posts_count, :update_user_posts_count

  protected

  def update_user_posts_count
    user = User.find(user_id)
    user.update_attributes!(:posts_count => user.posts_count + 1)
  end

  def update_topic_posts_count
    self.topics.posts_count += 1
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
