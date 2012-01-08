# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'blabbr_core/version'

Gem::Specification.new do |s|
  s.name         = "blabbr_core"
  s.version      = BlabbrCore::VERSION
  s.authors      = ["chatgris"]
  s.email        = "jboyer@af83.com"
  s.homepage     = "https://github.com/chatgris/blabbr_core"
  s.summary      = "Core of blabbr app"
  s.description  = "Core of blabbr app"
  s.files        = `git ls-files app lib`.split("\n")
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.add_dependency "mongoid",       "~>2.4"
  s.add_dependency "bson_ext",      "~>1.5"
  s.add_development_dependency "rspec",         "~>2.8"
  s.add_development_dependency "fuubar"
  s.add_development_dependency "mongoid-rspec"
  s.add_development_dependency "factory_girl"
  s.add_development_dependency "autotest-standalone"
  s.add_development_dependency "faker"
end
