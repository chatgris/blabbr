class Subscriber
  include Mongoid::Document

  field :nickname, :type => String
  field :message, :type => Integer, :default => 1
  
end
