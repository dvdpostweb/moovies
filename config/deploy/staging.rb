server '217.112.190.50', port: 23051, roles: [:web, :app, :db], primary: true

set :repo_url,        'git@github.com:dvdpost/moovies.git'
set :application,     'plush'
set :user,            'deploy'
set :puma_threads,    [4, 16]
set :puma_workers,    0

# Don't change these unless you know what you're doing
set :pty,             true
set :use_sudo,        false
set :stage,           :staging
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/webapps/#{fetch(:application)}/staging"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord

## Defaults:
# set :scm,           :git
# set :branch,        :master
# set :format,        :pretty
# set :log_level,     :debug
# set :keep_releases, 5

## Linked Files & Directories (Default None):
# set :linked_files, %w{config/database.yml}
# set :linked_dirs,  %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end
















# #set :default_environment, {
# #    'PATH' => "/opt/ruby-1.9.3-p448/bin:/opt/ruby/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/opt/ruby/bin::/opt/ruby/bin:",
# #    'GEM_HOME' => '/opt/ruby-1.9.3-p448/lib/ruby/gems/1.9.1',
# #    'GEM_PATH' => '/opt/ruby-1.9.3-p448/lib/ruby/gems/1.9.1',
# #    'BUNDLE_PATH' => '/opt/ruby-1.9.3-p448/lib/ruby/gems/1.9.1/gems'
# #}

# #############################################################
# #	Application
# #############################################################

# set :application, "moovies"
# set :deploy_to, "/home/webapps/plush/staging"

# #############################################################
# #	Settings
# #############################################################

# default_run_options[:pty] = true
# ssh_options[:forward_agent] = true
# set :use_sudo, false
# set :scm_verbose, true
# set :rails_env, "staging"
# set :keep_releases, 5

# #############################################################
# #	Servers
# #############################################################

# set :user, "plush"
# set :domain, "217.112.190.50"
# set :port, 23051
# role :app, domain
# role :web, domain

# role :db, domain, :primary => true

# #############################################################
# #	Git
# #############################################################

# set :scm, :git
# set :branch, "upgrade_all"
# set :scm_user, 'it@dvdpost.be'
# set :scm_passphrase, "[y'|\E7U158]9*"
# set :repository, "git@github.com:dvdpost/moovies.git"
# set :deploy_via, :remote_cache

# #############################################################
# #	Passenger
# #############################################################

# namespace :deploy do

#   # Restart passenger on deploy
#   desc "Restarting mod_rails with restart.txt"
#   task :restart, :roles => :app, :except => {:no_release => true} do
#     run "touch #{current_path}/tmp/restart.txt"
#   end

#   [:start, :stop].each do |t|
#     desc "#{t} task is a no-op with mod_rails"
#     task t, :roles => :app do
#       ;
#     end
#   end

# end

# after "deploy:restart", "deploy:cleanup"
