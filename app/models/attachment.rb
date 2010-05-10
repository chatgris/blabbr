require 'carrierwave/orm/mongoid'

class Attachment
  include Mongoid::Document

  field :nickname, :type => String
  field :attachment, :type => String

  mount_uploader :attachment, AttachmentUploader

  embedded_in :attachmentable, :inverse_of => :attachments

  validates_presence_of :nickname

end
