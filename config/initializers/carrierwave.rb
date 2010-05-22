CarrierWave.configure do |config|
  config.grid_fs_database = Mongoid.database.name
  config.grid_fs_host = Mongoid.database.connection.host
  config.grid_fs_access_url = "/uploads"
  config.storage = :grid_fs
end
