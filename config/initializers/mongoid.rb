module Mongoid

  File.open(File.join(Rails.root, 'config/database.mongo.yml'), 'r') do |f|
    @settings = YAML.load(f)[Rails.env]
  end

  Mongoid.configure do |config|
    name = @settings["database"]
    host = @settings["host"]
    config.master = Mongo::Connection.new(
      host,
      @settings["port"],
      {:logger => Rails.logger}).db(name)
  end
end

CarrierWave.configure do |config|
  config.grid_fs_database = Mongoid.database.name
  config.grid_fs_host = Mongoid.database.connection.host
  config.grid_fs_access_url = "/images"
  config.storage = :grid_fs
end

Stateflow.persistence = :mongoid
