# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Moovies::Application.initialize!

RouteTranslator.config do |config|
  config.force_locale = true
end
