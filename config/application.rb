require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "rails/test_unit/railtie"
require 'will_paginate'

# Auto-require default libraries and those for the current Rails environment.
Bundler.require :default, Rails.env

module Blabbr
  class Application < Rails::Application
     config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
     config.i18n.default_locale = :fr
     config.generators do |g|
#       g.orm             :active_record
       g.template_engine :haml
       g.test_framework  :test_unit, :fixture => true
     end
    config.filter_parameters << :password
  end
end
