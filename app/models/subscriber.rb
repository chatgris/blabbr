class Subscriber
  include Mongoid::Document

  embedded_in :topic, :inverse_of => :subscribers

  field :nickname, :type => String
  field :message, :type => Integer, :default => 1

end
