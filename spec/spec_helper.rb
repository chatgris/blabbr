# encoding: utf-8

path = File.expand_path(File.dirname(__FILE__) + '/../lib/')
$LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)

ENV['RACK_ENV'] = 'test'

require 'blabbr_core'
require 'mongoid-rspec'
require 'faker'
require 'factory_girl'

Mongoid.load!("config/mongoid.yml", :test)

RSpec.configure do |config|
  # Factories
  Dir[File.dirname(__FILE__) + "/factories/**/*.rb"].each {|file| require file }

  config.include Mongoid::Matchers

  config.before :each do
    Mongoid.purge!
    Mongoid::IdentityMap.clear
  end

  config.after :suite do
    Mongoid.purge!
    Mongoid::IdentityMap.clear
  end
end
