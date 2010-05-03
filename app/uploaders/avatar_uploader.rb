class AvatarUploader < CarrierWave::Uploader::Base

  def store_dir
    'images/avatars'
  end

  def filename
    model.permalink + '.jpg'
  end

end
