class AvatarUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick
  storage :file
  process :resize_to_fit => [100, 200]
  process :convert => 'png'

  def store_dir
    'images/avatars'
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
    model.permalink + '.png'
  end

  def default_url
    "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  end

end
