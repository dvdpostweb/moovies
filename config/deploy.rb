require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'thinking_sphinx/capistrano'
require './config/boot'
require 'capistrano/slack'
require 'capistrano/npm'
require "capistrano-rbenv"

set :rbenv_ruby_version, "2.3.3p222"
set :rbenv_path, '/home/webapps/plush/.rbenv/'

set :stages, %w(staging production)
set :default_stage, "staging"
set :whenever_command, "bundle exec whenever"


set :deployer do
  name = `git config user.name`.strip
  name = `whoami`.strip if name == ''
  name
end

set :slack_webhook_url, 'https://hooks.slack.com/services/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'
set :slack_room, 'general'
set :slack_subdomain, 'dvdpost'
set :slack_emoji, ':shipit:'
set :slack_deploy_defaults, false

namespace :slack do
  task :starting do
    slack_connect "#{fetch(:deployer)} *started* deploying Plush branch #{fetch(:branch)} to *#{fetch(:stage)}*. :rocket:"
  end

  task :finished do
    slack_connect "#{fetch(:deployer)} *finished* deploying Plush branch #{fetch(:branch)} to *#{fetch(:stage)}*. :star2:"
  end
end

before 'deploy:update_code', 'slack:starting'
after 'deploy:restart', 'slack:finished'

after 'deploy:create_symlink' do
  run "ln -nfs /data/geoip/GeoIP.dat #{current_path}/GeoIP.dat"
end

after 'deploy:finalize_update', 'npm:install'
