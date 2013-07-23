require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'thinking_sphinx/deploy/capistrano'

set :stages, %w(staging production)
set :default_stage, "staging"
set :whenever_command, "bundle exec whenever"