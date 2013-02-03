# encoding: utf-8
require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require "cancan/matchers"

  Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
  Dir["#{File.dirname(__FILE__)}/mock/**/*.rb"].each {|f| require f}

  RSpec.configure do |config|
    config.mock_with :rspec
    config.render_views

    config.before(:each) do
      Mongoid.master.collections.select { |c| c.name != 'system.indexes' }.each(&:drop)
    end

  end
end

Spork.each_run do
  load "#{Rails.root}/config/routes.rb"
  Dir["#{Rails.root}/app/**/*.rb"].each { |f| load f }
end
