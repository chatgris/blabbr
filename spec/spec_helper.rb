# encoding: utf-8

path = File.expand_path(File.dirname(__FILE__) + '/../lib/')
$LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)

require 'blabbr_core'
require 'mongoid-rspec'
require 'faker'
require 'factory_girl'

Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db('blabbr_core_spec')
  config.identity_map_enabled = true
end

RSpec.configure do |config|
  # Factories
  Dir[File.dirname(__FILE__) + "/factories/**/*.rb"].each {|file| require file }

  config.include Mongoid::Matchers

  config.after :each do
    Mongoid.master.collections.reject { |c| c.name =~ /^system\./ }.each(&:drop)
  end
end
