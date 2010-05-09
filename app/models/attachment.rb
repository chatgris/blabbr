require 'carrierwave/orm/mongoid'

class Attachment
  include Mongoid::Document

  field :nickname, :type => String
  field :avatar, :type => String
  field :attachment, :type => String

  mount_uploader :attachment, AttachmentUploader

  embedded_in :topic, :inverse_of => :subscribers

  validates_presence_of :nickname

end
