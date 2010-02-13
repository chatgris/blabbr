RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'haml'
  config.gem 'mongo_mapper', :version => '0.6.10'
  config.gem 'mongo_ext', :lib => false, :version => '0.18.2'
  config.gem 'mongo', :version => '0.18.2'
  config.gem 'will_paginate', :version => '2.3.12', :lib => 'will_paginate'
  config.gem 'RedCloth'
  config.i18n.load_path += Dir[File.join(RAILS_ROOT, 'config', 'locales', '**', '*.{rb,yml}')]
  config.frameworks -= [:active_record]
  config.time_zone = 'UTC'
end

require 'RedCloth'
