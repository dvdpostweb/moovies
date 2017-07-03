Moovies::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  #config.action_controller.asset_host = "http://www.plush.be"

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx


  config.assets.precompile += %w(
  bootstrap.min.css
  bootstrap-datepicker.css
  jquery-ui.min.css.scss
  slick.css
  jquery.tagit.css.scss
  ion.rangeSlider.css
  ion.rangeSlider.skinSimple.css
  iCheck.css.scss
  general.scss
  styles.scss
  bootstrap-chosen.css
  fancybox.scss
  products/catalog.js
  )


  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"
  config.action_dispatch.ip_spoofing_check = false

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.cache_store = :mem_cache_store, '192.168.100.204:11211'
  config.i18n.available_locales = [:fr, :nl, :en]
  config.i18n_cache_store = ActiveSupport::Cache.lookup_store(:mem_cache_store, '192.168.100.204:11211', :namespace => "production")
  config.i18n.enforce_available_locales = false
  I18n.config.enforce_available_locales = false

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default_url_options = {
    :host => "www.plush.be",
    :only_path => false
  }
  RouteTranslator.config do |config|
    config.force_locale = true
  end

end
