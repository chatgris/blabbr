class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Stateflow

  field :body, :type => String
  field :state, :type => String

  referenced_in :topic
  referenced_in :user

  attr_accessor :new_topic

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

  after_create :update_user_posts_count, :update_topic_infos

  protected

  def update_user_posts_count
      u = User.find(user_id)
      u.posts_count += 1
      u.save
  end

  def update_topic_infos
    if self.new_topic.nil?
      t = Topic.by_slug(self.topic.slug).first
      if t
        t.posted_at = Time.now.utc
        t.posts_count += 1
        t.members.each do |member|
          if member.unread == 0
            member.post_id = self.id
            member.page = (self.topic.posts_count.to_f / PER_PAGE.to_f).ceil
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
