class Subscriber
  include MongoMapper::EmbeddedDocument

  key :nickname, String
  key :message, Integer
  
end
