class Subscriber
  include Mongoid::Document

  field :nickname, :type => String
  field :message, :type => Integer, :default => 1

  embedded_in :topic, :inverse_of => :subscribers

  validates_presence_of :nickname

end
