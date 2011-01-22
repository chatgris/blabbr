require 'carrierwave/orm/mongoid'

class Attachment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :nickname, :type => String

  mount_uploader :attachment, ::AttachmentUploader

  embedded_in :topic

  validates :nickname, :presence => true

  before_create :update_attachments_count

  protected

  def update_attachments_count
    self.topic.members.each do |member|
      if member.nickname == nickname
        member.attachments_count += 1
      end
    end
    self.topic.attachments_count =+ 1
    self.topic.save
  end

end
