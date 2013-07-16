Moovies::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true
  config.cache_store = :mem_cache_store, '192.168.100.206:11211'
  config.i18n_cache_store = ActiveSupport::Cache.lookup_store(:mem_cache_store, '192.168.100.206:11211', :namespace => "development")

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true
  config.i18n.available_locales = [:fr, :nl, :en]
  config.secret_token = '4a0da00283de30200da69abbc3802f03b4bd63d0531baaec85b9bd3d3e83e2f204e538cd9445c0ec292cbb0382fe6673fe34ab401d8b7d4f788e84e1eab4027b'  
end
