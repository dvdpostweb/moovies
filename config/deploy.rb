lock "3.8.2"

set :application, "moovies"
set :deploy_user, 'plush'

set :repo_url, "git@github.com:dvdpost/moovies.git"

set :rbenv_type, :user
set :rbenv_ruby, '2.3.4'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all

set :keep_releases, 5

after 'deploy:create_symlink' do
  run "ln -nfs /data/geoip/GeoIP.dat #{current_path}/GeoIP.dat"
end
