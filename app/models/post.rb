class Post
  include MongoMapper::Document
  
  key :topic_id, ObjectId
  key :creator, String
  key :content, String
  
  timestamps!
  
end
