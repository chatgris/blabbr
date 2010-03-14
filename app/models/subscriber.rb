class Subscriber
  include Mongoid::Document

  field :nickname, :type => String
  field :message, :type => Integer, :default => 0
  
  protected
  
  def self.increment_unread(topic)
    topic.update_attributes(:posts_count => topic.posts_count.to_i + 1)
  end
  
end
