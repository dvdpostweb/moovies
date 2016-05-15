require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'thinking_sphinx/capistrano'
require './config/boot'
require 'capistrano-slack-notify'

set :stages, %w(staging production)
set :default_stage, "staging"
set :whenever_command, "bundle exec whenever"
set :slack_webhook_url,   "https://hooks.slack.com/services/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"


before 'deploy', 'slack:starting'
after  'deploy', 'slack:finished'
before 'deploy:rollback', 'slack:failed'

after 'deploy:create_symlink' do
  run "ln -nfs /data/geoip/GeoIP.dat #{current_path}/GeoIP.dat"
end