class Subscriber
  include Mongoid::Document

  field :nickname, :type => String
  field :unread, :type => Integer, :default => 0

  embedded_in :topic, :inverse_of => :subscribers

  validates_presence_of :nickname

end
