class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Stateflow

  field :body, :type => String
  field :state, :type => String

  referenced_in :topic
  referenced_in :user

  attr_accessor :new_topic, :creator

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

  before_validation :set_creator_id, :if => "self.new_record?"
  after_create :update_user_posts_count, :update_topic_infos

  protected

  def set_creator_id
    self.user_id = self.creator.id
  end

  def update_user_posts_count
    self.creator.inc(:posts_count, 1)
  end

  def update_topic_infos
    if self.new_topic.nil?
      t = Topic.by_slug(self.topic.slug).first
      if t
        t.posted_at = Time.now.utc
        t.members.each do |member|
          if member.unread == 0
            member.post_id = self.id
            member.page = (self.topic.posts_count.to_f / PER_PAGE.to_f).ceil
          end
          if member.nickname == self.creator.nickname
            member.inc(:posts_count, 1)
          else
            member.inc('unread', 1)
          end
        end
        t.inc('posts_count', 1)
        t.save
      end
    end
  end

end
