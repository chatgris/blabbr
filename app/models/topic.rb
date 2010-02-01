class Topic
  include MongoMapper::Document
  
  key :creator, String, :required => true
  key :title, String, :required => true, :unique => true
  key :permalink, String, :required => true
  key :posts_count, Integer
  
  timestamps!
  
  many :subscribers
  many :posts
  
  before_validation_on_create :set_permalink
  
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

