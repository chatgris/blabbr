# encoding: utf-8
class SmileyUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process :get_dimensions
  process :resize_to_limit => [200, 200]

  def get_dimensions
    if @file
      img = MiniMagick::Image.open(@file.file)
      {:height => img[:height], :width => img[:width]}
    end
  end

  def store_dir
    'smilies'
  end

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def max_file_size
    51200
  end

  def filename
    model.code + File.extname(super.to_s)
  end

end
