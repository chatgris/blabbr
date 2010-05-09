class Attachment
  include Mongoid::Document

  field :nickname, :type => String

  embedded_in :topic, :inverse_of => :subscribers

  validates_presence_of :nickname

end
