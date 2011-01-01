require 'carrierwave/orm/mongoid'

class Attachment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :nickname, :type => String

  mount_uploader :attachment, ::AttachmentUploader

  embedded_in :attachmentable, :polymorphic => true

  validates :nickname, :presence => true

  before_create :update_attachments_count

  protected

  def update_attachments_count
    self.attachmentable.members.each do |member|
      if member.nickname == nickname
        member.inc(:attachments_count, 1)
      end
    end
    self.attachmentable.inc(:attachments_count, 1)
  end

end
