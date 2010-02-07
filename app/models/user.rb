class User
  
  include MongoMapper::Document
 
  key :nickname,  String, :required => true, :unique => true
  key :email,  String, :required => true
  key :identity_url, String
  key :posts_count, Integer, :default => 0
  
  many :posts
  
  protected
  
  def self.users_except_creator(creator)
    User.find(:all, 
              :order => "nickname",
              :conditions => { 
                :_id => {'$ne' => creator} } )
  end

end
