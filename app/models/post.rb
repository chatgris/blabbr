class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :nickname, :type => String
  field :content, :type => String
  
  belongs_to :topics, :inverse_of => :posts
  
end
