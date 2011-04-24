class Member
  include Mongoid::Document
  include Mongoid::Slug

  field :nickname, :type  => String
  field :unread, :type => Integer, :default => 0
  field :page, :type => Integer, :default => 1
  field :post_id, :type  => String
  field :posts_count, :type => Integer, :default => 0
  field :attachments_count, :type => Integer, :default => 0

  embedded_in :topic
  slug_field :nickname

  validates :nickname, :presence => true, :uniqueness => true

end
