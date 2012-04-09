# encoding: utf-8
source :rubygems

gem 'sinatra', git: 'git://github.com/sinatra/sinatra.git'
gem 'warden'
gem 'thin'

gem "mongoid",       "~>2.4"
gem "bson_ext",      "~>1.5"
gem "simple_states", "~> 0.0.11"
gem "fromage"
gem "uglifier"
gem "bcrypt-ruby"
gem 'alphasights-sinatra-sprockets',
  git: "git@github.com:chatgris/sinatra-sprockets.git",
  branch: 'require',
  require: 'sinatra/sprockets'

group :test do
  gem "rspec",         "~>2.8"
  gem "fuubar"
  gem "mongoid-rspec"
  gem "factory_girl"
  gem "autotest-standalone"
  gem "faker"
end
