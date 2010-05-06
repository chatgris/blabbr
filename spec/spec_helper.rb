# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require 'rubygems'
require 'factory_girl'

require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)
require 'rails/test_help'
require 'rspec/rails'
require 'rspec/expectations'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

Rspec.configure do |config|

  config.before :all do
    Mongoid.database.collections.each(&:drop)
  end

  config.after :all do
    Mongoid.database.collections.each(&:drop)
  end

  config.include Rspec::Matchers
  config.mock_with :rspec

end
