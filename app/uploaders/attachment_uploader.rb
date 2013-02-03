# encoding: utf-8
class AttachmentUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def store_dir
    "attachments"
  end

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
