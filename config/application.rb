require File.expand_path('../boot', __FILE__)
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "sprockets/railtie"
require 'rubygems'
require 'composite_primary_keys'
if defined?(Bundler)
  Bundler.require *Rails.groups(:assets => %w(development test))
end
module Moovies
  class Application < Rails::Application
    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins "http://staging.plush.lu/#{I18n.locale}"
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end
    config.time_zone = 'Brussels'
    config.active_record.default_timezone = :local
    config.exceptions_app = self.routes
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.assets.enabled = true
    config.assets.version = '1.0'
    config.autoload_paths += %W(#{config.root}/lib)
    config.paths["config/routes"] += Dir[Rails.root.join("config/routes/*.rb")]
    config.to_prepare do
      Devise::Mailer.layout "email"
      Devise::Mailer.helper "application"
    end
    config.to_prepare do
      ActionMailer::Base.helper "application"
    end
    #if Rails.env.development?
    #  config.session_store :redis_store, servers: ["redis://localhost:6379/0/session"]
    #end
  end
end
