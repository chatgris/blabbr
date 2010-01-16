class User
  
  include MongoMapper::Document
 
  key :nickname,  String , :unique => true
  key :email,  String
  key :identity_url, String
  
end
