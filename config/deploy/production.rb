load 'deploy/assets'
set :whenever_environment, defer { stage }
set :whenever_identifier, defer { "#{application}_#{stage}" }
set :whenever_command, "bundle exec whenever"

require "whenever/capistrano"

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
set :deploy_to, "/home/webapps/plush/production"

#############################################################
#	Settings
#############################################################

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :use_sudo, false
set :scm_verbose, true
set :rails_env, "production"
set :keep_releases, 5

#############################################################
#	Servers
#############################################################

set :user, "plush"
set :domain, "94.139.62.123"
set :domain2,  "94.139.62.122"
set :port, 22012
role :app, domain2, domain
role :web, domain2, domain

role :db, domain2,  :primary => true

#############################################################
#	Git
#############################################################

set :scm, :git
set :branch, "production"
set :scm_user, 'it@dvdpost.be'
set :scm_passphrase, "[y'|\E7U158]9*"
set :repository, "git@github.com:dvdpost/moovies.git"
set :deploy_via, :remote_cache

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

namespace :deploy do
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      from = source.next_revision(current_revision)
      if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        logger.info "precompile needed"
        run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end
  end
end

#namespace :deploy do
#  namespace :assets do
#    desc "Precompile assets on local machine and upload them to the server."
#    task :precompile, roles: :web, except: {no_release: true} do
#      run_locally "bundle exec rake assets:precompile"
#      find_servers_for_task(current_task).each do |server|
#        run_locally "rsync -vr --exclude='.DS_Store' public/assets #{user}@#{server.host}:#{shared_path}/"
#      end
#    end
#  end
#end

after "deploy:restart", "deploy:cleanup"