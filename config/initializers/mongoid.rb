File.open(File.join(Rails.root, 'config/database.mongo.yml'), 'r') do |f|
  SETTINGS = YAML.load(f)[Rails.env]
end

module Mongoid

  Mongoid.configure do |config|
    name = SETTINGS["database"]
    host = SETTINGS["host"]
    config.master = Mongo::Connection.new(
      host,
      SETTINGS["port"],
      {:logger => Rails.logger}).db(name)
  end
end

CarrierWave.configure do |config|
  config.grid_fs_database = SETTINGS['database']
  config.grid_fs_host = SETTINGS['host']
  config.grid_fs_access_url = "/avatar"
  #config.storage = :grid_fs
end
