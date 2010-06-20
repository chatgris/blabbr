CarrierWave.configure do |config|
  config.grid_fs_database = Mongoid.database.name
  config.grid_fs_host = Mongoid.config.master.connection.host
  config.grid_fs_port = Mongoid.config.master.connection.port
  unless Mongoid.config.master.connection.auths.empty?
    config.grid_fs_username = Mongoid.config.master.connection.auths[0]["username"]
    config.grid_fs_password = Mongoid.config.master.connection.auths[0]["password"]
  end
  config.storage = :grid_fs
  config.grid_fs_access_url = "/uploads"
end
