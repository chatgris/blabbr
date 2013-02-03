# encoding: utf-8
require 'mongo'

class GridfsController < ActionController::Metal
  def serve
    gridfs_path = env["PATH_INFO"].gsub("/uploads/", "")
    begin
      gridfs_file = Mongo::GridFileSystem.new(Mongoid.database).open(gridfs_path, 'r')
      self.response_body = gridfs_file.read
      self.content_type = gridfs_file.content_type
      self.headers['Cache-Control'] = 'public, max-age=2592000'
    rescue
      self.status = :file_not_found
      self.content_type = 'text/plain'
    end
  end
end
