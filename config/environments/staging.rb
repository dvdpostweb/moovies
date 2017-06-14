Moovies::Application.configure do

  config.action_controller.asset_host = "http://staging.plush.be"

  js_prefix    = 'app/assets/javascripts/'
  style_prefix = 'app/assets/stylesheets/'

  javascripts = Dir["#{js_prefix}**/*.js"].map      { |x| x.gsub(js_prefix,    '') }
  css         = Dir["#{style_prefix}**/*.css"].map  { |x| x.gsub(style_prefix, '') }
  scss        = Dir["#{style_prefix}**/*.scss"].map { |x| x.gsub(style_prefix, '') }

  Rails.application.config.assets.precompile = (javascripts + css + scss)

  config.assets.precompile += %w(
  font-awesome.css
  styles.css
  jquery.js
  jquery.form.js
  jquery_ujs.js
  )

  # #carrefourbonus/validation.js
  # contact/questions.js
  # customers/credit_card_modification.js
  # customers/mon_compte.js
  # devise/change_password.js
  # devise/login.js
  # devise/password.js
  # devise/registration.js
  # faq/public_faq.js
  # info/alacarte.js
  # info/freetrial.js
  # messages/messages.js
  # orange/lu/auth/sms.js
  # payment_methods/credit_card_tvod.js
  # payment_methods/redirect_to_ogone.js
  # photobox/validation.js
  # products/catalog.js
  # steps/step3.js
  # steps/step4.js
  # streaming_products/streaming.js
  # top_banner/validation.js
  # vod/sample.js
  # watchlist/watchlist.js

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

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  #config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  config.action_mailer.default_url_options = {
    :host => "staging.plush.be",
    :only_path => false
  }
  config.action_mailer.delivery_method = :smtp
  config.log_level = :debug
  config.i18n.available_locales = [:fr, :nl, :en]

  config.cache_store = :mem_cache_store, '192.168.100.206:11211'
  config.i18n_cache_store = ActiveSupport::Cache.lookup_store(:mem_cache_store, '192.168.100.206:11211', :namespace => "staging")
  config.i18n.enforce_available_locales = false
  I18n.config.enforce_available_locales = false

  RouteTranslator.config do |config|
    config.force_locale = true
  end

end
