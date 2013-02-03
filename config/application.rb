# encoding: utf-8
require File.expand_path('../boot', __FILE__)

YAML::ENGINE.yamler = 'syck'
# Pick the frameworks you want:
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "sprockets/railtie"
require "mongoid/railtie"

# Auto-require default libraries and those for the current Rails environment.
Bundler.require :default, Rails.env

module Blabbr
  class Application < Rails::Application
     config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
     config.i18n.default_locale = :en
     config.time_zone = "UTC"
     config.assets.paths << Rails.root.join('vendor', 'assets')
     config.assets.paths << Rails.root.join('lib', 'assets')
     config.assets.enabled = true
     config.force_ssl unless ENV['SSL'].nil?
     config.generators do |g|
       g.orm             :mongoid
       g.template_engine :haml
       g.integration_tool :rspec
       g.test_framework   :rspec
     end
    config.filter_parameters += [:password, :password_confirmation]
    config.mongoid.preload_models = false
    if Rails.env.test?
      initializer :after => :initialize_dependency_mechanism do
        ActiveSupport::Dependencies.mechanism = :load
      end
    end
  end
end
