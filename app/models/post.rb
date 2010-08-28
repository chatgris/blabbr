class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Stateflow

  field :body
  field :state

  referenced_in :topic
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

  after_validation :set_unread, :update_user_posts_count, :update_posted_at

  protected

  def update_user_posts_count
    if self.new_record?
      User.find(user_id).update_attributes!(:posts_count => user.posts_count + 1)
    end
  end

  def update_posted_at
    if self.new_record? && self.topic
      t = Topic.by_permalink(self.topic.permalink).first
      if t
        t.posted_at = Time.now.utc
        t.posts_count += 1
        t.save
      end
    end
  end

  def set_unread
    if self.new_record? && self.topic
      t = Topic.by_permalink(self.topic.permalink).first
      if t
        t.members.each do |member|
          if member.unread == 0
            member.post_id = self.id
            member.page = self.topic.posts_count / PER_PAGE + 1
          end
          if member.nickname == self.user.nickname
            member.posts_count += 1
          else
            member.unread += 1
          end
        end
        t.save
      end
    end
  end

end
