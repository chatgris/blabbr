# encoding: utf-8
require 'mongoid'
require 'state_machine'

module BlabbrCore
end

# Libs
Dir[File.dirname(__FILE__) + "/blabbr_core/lib/*.rb"].each {|file| require file }

# Mongoid model
Dir[File.dirname(__FILE__) + "/blabbr_core/persistence/*.rb"].each {|file| require file }

# Mongoid Observers
Dir[File.dirname(__FILE__) + "/blabbr_core/observers/*.rb"].each {|file| require file }
Mongoid.observers = BlabbrCore::PostObserver
Mongoid.instantiate_observers

# BlabbrCore domains
Dir[File.dirname(__FILE__) + "/blabbr_core/domains/*.rb"].each {|file| require file }
