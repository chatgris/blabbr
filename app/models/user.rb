class User
  include Mongoid::Document
  include Mongoid::Timestamps
 
  field :nickname,  :type => String
  field :email,  :type => String
  field :identity_url, :type => String
  field :posts_count, :type => Integer, :default => 0
  field :locale, :type => String, :default => 'fr'
  
  has_many :posts
  
#  validates_uniqueness_of :nickname, :email, :identity_url
  validates_presence_of :email, :identity_url
  
  named_scope :by_identity_url, lambda { |identity_url| { :where => { :identity_url => identity_url}}}
  
  protected
  
  def self.users_except_creator(creator)
    User.all( 
            :order => "nickname",
            :conditions => { 
              :_id => {'$ne' => creator} } )
  end

end
