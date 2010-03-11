class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :user, String
  field :content, String
  
  belongs_to :topics, :inverse_of => :posts
  
  timestamps!
  
end
