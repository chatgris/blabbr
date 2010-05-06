class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Stateflow

  field :nickname, :type => String
  field :content, :type => String
  field :state, :type => String

  embedded_in :topics, :inverse_of => :posts

  stateflow do
      initial :published

      state :published, :deleted

      event :delete! do
        transitions :from => :published, :to => :delete
      end

      event :publish do
        transitions :from => :deleted, :to => :published
      end
    end

  validates_presence_of :content, :nickname

  after_create :update_user_posts_count

  protected

  def update_user_posts_count
    user = User.where(:nickname => self.nickname).first
    user.update_attributes(:posts_count => user.posts_count + 1)
  end

end
