require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'thinking_sphinx/capistrano'
require './config/boot'

set :stages, %w(staging production)
set :default_stage, "staging"
set :whenever_command, "bundle exec whenever"


set :deployer do
  name = `git config user.name`.strip
  name = `whoami`.strip if name == ''
  name
end

after 'deploy:create_symlink' do
  run "ln -nfs /data/geoip/GeoIP.dat #{current_path}/GeoIP.dat"
end
