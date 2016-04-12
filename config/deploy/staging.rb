set :default_environment, {
    'PATH' => "/opt/ruby-1.9.3-p448/bin:/opt/ruby/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/opt/ruby/bin::/opt/ruby/bin:",
    'GEM_HOME' => '/opt/ruby-1.9.3-p448/lib/ruby/gems/1.9.1',
    'GEM_PATH' => '/opt/ruby-1.9.3-p448/lib/ruby/gems/1.9.1',
    'BUNDLE_PATH' => '/opt/ruby-1.9.3-p448/lib/ruby/gems/1.9.1/gems'
}

#############################################################
#	Application
#############################################################

set :application, "moovies"
set :deploy_to, "/home/webapps/plush/staging"

#############################################################
#	Settings
#############################################################

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :use_sudo, false
set :scm_verbose, true
#set :rails_env, "staging"
set :keep_releases, 5

#############################################################
#	Servers
#############################################################

set :user, "plush"
set :domain,  "217.112.190.50"
set :port, 23051
role :app, domain
role :web, domain

role :db, domain,  :primary => true

#############################################################
#	Git
#############################################################

set :scm, :git
set :branch, "master"
set :scm_user, 'it@dvdpost.be'
set :scm_passphrase, "[y'|\E7U158]9*"
set :repository, "git@github.com:dvdpost/moovies.git"
set :deploy_via, :remote_cache







set :puma_threads,    [4, 16]
set :puma_workers,    4

# Don't change these unless you know what you're doing
set :pty,             true
set :use_sudo,        false
set :stage,           :staging
#set :deploy_via,      :remote_cache
#set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, false  # Change to true if using ActiveRecord

#############################################################
#	Passenger
#############################################################

namespace :deploy do

  # Restart passenger on deploy
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => {:no_release => true} do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

end

after "deploy:restart", "deploy:cleanup"