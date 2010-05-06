require 'mongo'

require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)

class GridfsServeImage
  def self.call(env)
    if env["PATH_INFO"] =~ /^\/images\/(.+)$/
      begin
        Mongo::GridFileSystem.new(Mongoid.database).open($1, 'r') do |file|
          [200, { 'Content-Type' => file.content_type }, [file.read]]
        end
      rescue
        [404, { 'Content-Type' => 'text/plain' }, ['File not found.']]
      end
    else
      [404, { "Content-Type" => "text/html", "X-Cascade" => "pass" }, ["Not Found"]]
    end
  end
end
