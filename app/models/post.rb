class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include AASM

  field :nickname, :type => String
  field :content, :type => String
  field :status

  aasm_column :status

  embedded_in :topics, :inverse_of => :posts

  aasm_initial_state :published

  aasm_state :published
  aasm_state :deleted

  aasm_event :delete do
    transitions :to => :deleted, :from => [:published]
  end

  aasm_event :publish do
    transitions :to => :published, :from => [:deleted]
  end

  validates_presence_of :content, :nickname

  after_create :update_user_posts_count

  protected

  def update_user_posts_count
    user = User.where(:nickname => self.nickname).first
    user.update_attributes(:posts_count => user.posts_count + 1)
  end

end
