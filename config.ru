# This file is used by Rack-based servers to start the application.
require 'sass/plugin/rack'
use Sass::Plugin::Rack
require ::File.expand_path('../config/environment',  __FILE__)
run Blabbr::Application
