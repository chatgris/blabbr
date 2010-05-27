class Member
  include Mongoid::Document

  field :nickname
  field :unread, :type => Integer, :default => 0
  field :page, :type => Integer, :default => 1
  field :post_id
  field :posts_count, :type => Integer, :default => 0

  embedded_in :topic, :inverse_of => :members

  validates_presence_of :nickname
  validates_uniqueness_of :nickname

end
