class AvatarUploader < CarrierWave::Uploader::Base

  storage :file

  def store_dir
    'images/avatars'
  end

  def filename
    model.permalink + '.jpg'
  end

end
