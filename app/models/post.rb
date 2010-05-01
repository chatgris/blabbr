class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  field :nickname, :type => String
  field :content, :type => String

  embedded_in :topics, :inverse_of => :posts

  validates_presence_of :content, :nickname

  after_create :update_user_posts_count

  protected

  def update_user_posts_count
    user = User.where(:nickname => self.nickname).first
    user.update_attributes(:posts_count => user.posts_count + 1)
  end

end
