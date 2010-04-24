class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  field :nickname, :type => String
  field :content, :type => String

  embedded_in :topics, :inverse_of => :posts

end
