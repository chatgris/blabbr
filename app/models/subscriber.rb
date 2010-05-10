class Subscriber
  include Mongoid::Document

  field :nickname
  field :unread, :type => Integer, :default => 0
  field :page, :type => Integer
  field :post_id

  embedded_in :topic, :inverse_of => :subscribers

  validates_presence_of :nickname

end
