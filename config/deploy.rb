require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'thinking_sphinx/capistrano'
require './config/boot'
require 'capistrano/puma'
set :stages, %w(staging production)
set :default_stage, "production"
set :whenever_command, "bundle exec whenever"

after 'deploy:create_symlink' do
  run "ln -nfs /data/geoip/GeoIP.dat #{current_path}/GeoIP.dat"
end