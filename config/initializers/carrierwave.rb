Mongoid.load!(Rails.root.join('config', 'mongoid.yml'))
CarrierWave.configure do |config|
  config.storage = :grid_fs
  config.grid_fs_connection = Mongoid.database
  config.grid_fs_access_url = "/uploads"
end
