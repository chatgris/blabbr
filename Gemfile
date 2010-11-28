source "http://rubygems.org"

gem "bson",                 "1.1.1"
gem "bson_ext",             "1.1.1"
gem "carrierwave",          "~>0.5.0"
gem "devise",               "~>1.1.5"
gem "haml",                 "~>3.0.24"
gem "jammit_lite",          :git => "git://github.com/chatgris/jammit_lite.git"
gem "mini_magick",          "~>3.1"
gem "mongoid",              "~>2.0.0.beta.20"
gem "pusher",               "~>0.6.0"
gem "rails",                "~>3.0.3"
gem "RedCloth",             "~>4.2.3"
gem "stateflow",            "~>0.2.3"

# async wrappers
gem 'eventmachine',         "1.0.0.beta.2"
gem 'rack-fiber_pool',      :require => 'rack/fiber_pool'
gem 'em-synchrony',         :git => 'git://github.com/igrigorik/em-synchrony.git', :require => ['em-synchrony', 'em-synchrony/iterator']

group :test, :development do
  gem "factory_girl_rails", "~>1.0"
  gem "rspec-rails",        "~>2.0.1"
end

group :development do
  gem "ClothRed",           "~>0.4.1"
  gem "nokogiri",           "~>1.4.3.1"
  gem "rbbcode",            "~>0.1.8"
  gem "jammit",             "~>0.5.3"
  gem 'thin',
end

group :production, :development do
  gem "dalli",              "~>0.9.7"
end
