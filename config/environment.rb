RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'haml'
  config.gem 'mongo_mapper'
  config.gem 'mongo_ext', :lib => false
  config.gem 'mongo'
  config.gem 'agnostic-will_paginate', :version => '3.0.0', :lib => 'will_paginate'
  config.gem 'RedCloth'
  config.frameworks -= [:active_record]
  config.time_zone = 'UTC'
end
