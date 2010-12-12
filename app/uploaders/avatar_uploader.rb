class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process :resize_to_fit => [80, 160]

  version :thumb do
    process :resize_to_fill => [25,25]
  end


  def store_dir
    'avatars'
  end

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def max_file_size
    512000
  end

  def filename
    model.slug + File.extname(super.to_s) unless super.nil?
  end

end
