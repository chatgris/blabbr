class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Stateflow

  field :nickname
  field :content
  field :state

  embedded_in :topics, :inverse_of => :posts

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

  validates_presence_of :content, :nickname

  after_create :set_unread, :update_user_posts_count

  protected

  def update_user_posts_count
    user = User.by_nickname(nickname).first
    user.update_attributes(:posts_count => user.posts_count + 1)
  end

  def set_unread
    self.topics.members.each do |member|
      if member.unread == 0
        member.post_id = self.id
        member.page = self.topics.posts_count / PER_PAGE + 1
      end
      member.unread += 1
    end
  end

end
