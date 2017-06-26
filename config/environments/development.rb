Moovies::Application.configure do

  config.react.variant = :production

  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.cache_store = :mem_cache_store, '127.0.0.1:11211'
  config.i18n_cache_store = ActiveSupport::Cache.lookup_store(:mem_cache_store, '127.0.0.1:11211', :namespace => "development")
  #config.cache_store = :redis_store, "redis://localhost:6379/0/cache"
  #config.i18n_cache_store = ActiveSupport::Cache.lookup_store(:redis_store, "redis://localhost:6379/0/cache", :namespace => "development")
  config.i18n.enforce_available_locales = false
  I18n.config.enforce_available_locales = false
  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.delivery_method = :letter_opener
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
  config.action_mailer.default_url_options = {
        :host => 'plush.dev',
        :only_path => false
  }
  RouteTranslator.config do |config|
    config.force_locale = true
  end
  config.assets.precompile += %w( jquery.ui.datepicker-fr.js jquery.ui.datepicker-nl.js jquery.ui.datepicker-en.js login.css promotions.css promotions.js errors.css )
  #BetterErrors.editor = :sublime
  Paypal.sandbox!
end
