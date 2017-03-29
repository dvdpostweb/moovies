require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'thinking_sphinx/capistrano'
require './config/boot'
require 'capistrano/slack'
require 'capistrano/notifier/mail'

set :stages, %w(staging production)
set :default_stage, "staging"
set :whenever_command, "bundle exec whenever"


set :deployer do
  name = `git config user.name`.strip
  name = `whoami`.strip if name == ''
  name
end

set :slack_webhook_url, 'https://hooks.slack.com/services/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' # comes from inbound webhook integration
set :slack_room, 'general'
set :slack_subdomain, 'dvdpost'
set :slack_emoji, ':shipit:'
set :slack_deploy_defaults, false # Provided tasks are weird, and hooks are quite absurd. Let's do it ourselves.

set :notifier_mail_options, {
    :method => :smtp,
    :from   => 'aleksandar.popovic@dvdpost.be',
    :to     => ['aleksandar.popovic@dvdpost.be', 'igor.markovic@dvdpost.be', 'stt@dvdpost.be', 'pierre.demolin@gmail.com', 'nidzoni@gmail.com'],
    :github => 'https://github.com/dvdpost/moovies',
    :smtp_settings => {
        address: "smtp.gmail.com",
        port: 587,
        domain: "gmail.com",
        authentication: "plain",
        enable_starttls_auto: true,
        user_name: 'aleksandar.popovic@dvdpost.be',
        password: 'l24popac'
    }
}

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
