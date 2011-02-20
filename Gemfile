source "http://rubygems.org"

gem "bson",                 "1.2"
gem "bson_ext",             "1.2"
gem "carrierwave",          "~>0.5.1"
gem "devise",               "~>1.1.5"
gem "haml",                 "~>3.0.24"
gem "jammit_lite",          :git => "git://github.com/chatgris/jammit_lite.git"
gem "mini_magick",          "~>3.1"
gem "mongo",                "1.2"
gem "mongoid",              "2.0.0.rc.7"
gem "pusher",               "~>0.7.0"
gem "rails",                "~>3.0.4"
gem "RedCloth",             "~>4.2.3"
gem "simple_form",          "~>1.3.0"
gem "stateflow",            "~>0.4.0"

# async wrappers
gem 'eventmachine',         "1.0.0.beta.2"
gem 'rack-fiber_pool',      :require => 'rack/fiber_pool'
gem 'em-synchrony',         :git => 'git://github.com/igrigorik/em-synchrony.git', :require => ['em-synchrony', 'em-synchrony/em-http', 'em-synchrony/iterator']
gem 'em-http-request',      :git => 'git://github.com/igrigorik/em-http-request'

group :test, :development do
  gem "mongoid-rspec",      :git => "git://github.com/durran/mongoid-rspec.git"
  gem "fabrication"
  gem "rspec-rails",        "~>2.5.0"
  gem "rcov"
  gem "autotest"
end

group :development do
  gem "ClothRed",           "~>0.4.1"
  gem "nokogiri",           "~>1.4.3.1"
  gem "rbbcode",            "~>0.1.8"
  gem "jammit",             "~>0.5.3"
  gem 'thin',
end

group :production, :development do
  gem "dalli",              "~>1.0.0"
end
