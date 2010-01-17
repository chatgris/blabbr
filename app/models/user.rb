class User
  
  include MongoMapper::Document
 
  key :nickname,  String , :unique => true
  key :email,  String
  key :identity_url, String
  
  protected
  
  def self.users_except_creator(creator)
    User.find(:all, 
              :order => "nickname",
              :conditions => { 
                :_id => {'$ne' => creator} } )
  end

end
