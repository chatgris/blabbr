class Topic
  include MongoMapper::Document
  
  key :creator, String
  key :title, String
  key :permalink, String
  
  timestamps!
  
  many :subscribers
  
  before_validation_on_create :set_permalink
  
  protected
  
  def set_permalink
    self.permalink = title.parameterize.to_s
  end
  
  def self.new_by_params(params, user)
    topic = Topic.new(:title => params[:title],
                      :creator => user.nickname)
    
    params[:subscribers].each do |subscriber|
      add_member(topic, subscriber)
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

