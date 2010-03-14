class User
  include Mongoid::Document
  include Mongoid::Timestamps
 
  field :nickname,  :type => String
  field :permalink, :type => String
  field :email,  :type => String
  field :identity_url, :type => String
  field :posts_count, :type => Integer, :default => 0
  field :locale, :type => String, :default => 'fr'
  
  has_many :posts
  
#  validates_uniqueness_of :nickname, :email, :identity_url
  validates_presence_of :nickname, :email, :identity_url
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  before_create :set_permalink
  
  named_scope :users_except_creator, lambda { |creator| where(:nickname.ne => creator) }
  named_scope :by_permalink, lambda { |permalink| { :where => { :permalink => permalink}}}
  
  protected
  
  def set_permalink
    self.permalink = nickname.parameterize.to_s
  end
  
  def self.increment(user)
    user.update_attributes(:posts_count => user.posts_count.to_i + 1)
  end
  
end
