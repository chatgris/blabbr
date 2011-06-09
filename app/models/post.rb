class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Stateflow
  include Rails.application.routes.url_helpers

  field :body, :type => String
  field :creator_n, :type => String
  field :creator_s, :type => String
  field :state, :type => String
  field :page, :type => Integer

  referenced_in :topic, :validate => false

  attr_accessor :new_topic, :creator
  paginates_per PER_PAGE

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
  validates :creator_n, :presence => true

  before_validation :set_page, :set_creator, :if => "self.new_record?"
  after_create :update_user_posts_count, :update_topic_infos, :ws_notify

  scope :for_creator, ->(creator) { where('creator_n' => creator)}

  def as_json(options={})
    super(:only => [:state, :page, :creator_n, :creator_s, :created_at],
          :methods => [:pid, :path, :content])
  end

  protected

  def path
    topic_post_path(self.topic, self)
  end

  def pid
    self.id.to_s
  end

  def content
    Textilize.new(self.body).to_html
  end

  def ws_notify
    begin
      if Pusher.key
          Pusher[topic.slug].trigger_async('new-post', {:id => self.id, :user_nickname => self.creator_n})
          Pusher[topic.slug].trigger_async('index', true)
        end
      rescue Pusher::Error => e
         $stderr.puts e
      end
  end

  def set_page
    @page = (self.topic.posts_count.to_f / PER_PAGE.to_f).ceil
    self.page = @page
  end

  def set_creator
    self.creator_n = self.creator.nickname
    self.creator_s = self.creator.slug
  end

  def update_user_posts_count
    self.creator.inc(:posts_count, 1)
  end

  def update_topic_infos
    if self.new_topic.nil?
      t = self.topic
      t.members.each do |member|
        if member.unread == 0
          member.post_id = self.id
          member.page = @page
        end
        member.nickname == self.creator.nickname ? member.posts_count += 1 : member.unread += 1
      end
      t.last_user = self.creator.nickname
      t.posted_at = Time.now.utc
      t.posts_count += 1
      t.save
    end
  end

end
