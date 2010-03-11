class Subscriber
  include Mongoid::Document

  field :nickname, :type => String
  field :message, :type => Integer
  
end
