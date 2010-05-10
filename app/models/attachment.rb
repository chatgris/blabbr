require 'carrierwave/orm/mongoid'

class Attachment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :nickname
  field :attachment

  mount_uploader :attachment, AttachmentUploader

  embedded_in :attachmentable, :inverse_of => :attachments

  validates_presence_of :nickname

end
