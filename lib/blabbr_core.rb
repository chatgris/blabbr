# encoding: utf-8
require 'mongoid'
require 'state_machine'

module BlabbrCore
end

# Mongoid model
Dir[File.dirname(__FILE__) + "/blabbr_core/models/*.rb"].each {|file| require file }

# Mongoid Observers
Dir[File.dirname(__FILE__) + "/blabbr_core/observers/*.rb"].each {|file| require file }
Mongoid.observers = BlabbrCore::PostObserver
Mongoid.instantiate_observers
