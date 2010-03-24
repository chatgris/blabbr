class Topic
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :creator, :type => String, :required => true
  field :title, :type => String, :required => true, :unique => true
  field :permalink, :type => String, :required => true
  field :posts_count, :type => Integer, :default => 1
  
  has_many :subscribers
  has_many :posts
  
  attr_accessor :post
  
#  validates_uniqueness_of :title, :permalink
  validates_presence_of :title, :permalink, :creator
  before_create :set_permalink
  
  named_scope :subscribed_topic, lambda { |current_user| { :where => { 'subscribers.nickname' => current_user}}}
  named_scope :by_permalink, lambda { |permalink| { :where => { :permalink => permalink}}}
  
  def add_subscriber(nickname)
    user = User.by_nickname(nickname.strip).flatten[0]
    if user
      subscribers.build(:nickname => nickname)
      save!
    else
      false
    end
  end
  
  def remove_subscriber!(nickname)
    subscribers.delete_if { |subscriber| subscriber.nickname == nickname }
    save!
  end
  
  protected
  
  def set_permalink
    self.permalink = title.parameterize.to_s
  end
  
  def self.new_topic(params, user)
    topic = Topic.new(:title => params[:title],
                      :creator => user.nickname)
    add_member(topic, user.nickname)
    add_post(topic, user.nickname, params[:post])
    topic
  end
  
  def self.add_member(topic, member, message = 0)
    topic.subscribers << Subscriber.new(:nickname => member)
  end
  
  def self.add_post(topic, member, content)
    topic.posts << Post.new(:nickname => member, :content => content)
  end
  
  def self.increment(topic)
    topic.posts_count += 1
    topic.subscribers.each do |subscriber|
      subscriber.message += 1
    end
    topic
  end
  
  def self.reset_unread_posts(topic, user)
    topic.subscribers.each do |subscriber|
      if subscriber.nickname == user && subscriber.message != 0
        subscriber.message = 0 
        topic.save
      end
    end
  end
  
end
