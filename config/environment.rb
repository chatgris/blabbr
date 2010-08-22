# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Blabbr::Application.initialize!
Sass::Plugin.options[:style] = :compressed
Sass::Plugin.options[:template_location] = File.join(Rails.root, "app", "stylesheets")

PER_PAGE = 50
PER_PAGE_INDEX = 15
