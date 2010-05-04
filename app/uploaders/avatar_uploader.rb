class AvatarUploader < CarrierWave::Uploader::Base

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
