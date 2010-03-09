class Post
  include MongoMapper::Document
  
  key :topic_id, ObjectId
  key :user_id, ObjectId
  key :content, String
  
  belongs_to :user
  belongs_to :topic
  
#  timestamps!
  
end
