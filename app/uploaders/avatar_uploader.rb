class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process :resize_to_fit => [80, 160]

  def store_dir
    'images/avatars'
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
    model.permalink + File.extname(super.to_s)
  end

end
