class Topic
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :creator, :type => String, :required => true
  field :title, :type => String, :required => true, :unique => true
  field :permalink, :type => String, :required => true
  field :posts_count, :type => Integer, :default => 1
  
#  has_many :subscribers
  has_many :posts
  
  validates_uniqueness_of :title, :permalink
  validates_presence_of :title, :permalink, :creator
  before_create :set_permalink
  
  protected
  
  def set_permalink
    self.permalink = title.parameterize.to_s
  end
  
  def self.new_by_params(params, user)
    topic = Topic.new(:title => params[:title],
                      :creator => user.nickname)
    unless params[:subscribers].nil?
      params[:subscribers].each do |subscriber|
        add_member(topic, subscriber)
      end
    end
    add_member(topic, user.nickname)
    topic
  end
  
  def self.add_member(topic, member, message = 0)
    topic.subscribers << Subscriber.new(:nickname => member)
  end
  
  def self.update_subscribers(params, topic)
    if params[:subscribers]
      topic.subscribers = []
      params['subscribers'].each do |subscriber|
        add_member(topic, subscriber)
      end
      add_member(topic, topic.creator)
    end
    topic.title = params[:title]
    topic.save
  end

end

