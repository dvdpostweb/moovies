lock "3.8.0"

set :application, "moovies"
set :deploy_user, 'plush'

set :repo_url, "git@github.com:dvdpost/moovies.git"

set :rbenv_type, :user
set :rbenv_ruby, '2.0.0-p648'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all

set :keep_releases, 5

#set :slack_url, 'https://hooks.slack.com/services/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'

#set :slack_channel, '#devops'
#set :slack_username, 'Deploybot'
#set :slack_emoji, ':trollface:'
#set :slack_user, ENV['GIT_AUTHOR_NAME']
#set :slack_fields, ['status', 'stage', 'branch', 'revision', 'hosts']
#set :slack_mrkdwn_in, ['pretext', 'text', 'fields']
#set :slack_hosts, -> { release_roles(:all).map(&:hostname).join("\n") }
#set :slack_text, -> {
#  elapsed = Integer(fetch(:time_finished) - fetch(:time_started))
#  "Revision #{fetch(:current_revision, fetch(:branch))} of " \
#  "#{fetch(:application)} deployed to #{fetch(:stage)} by #{fetch(:slack_user)} " \
#  "in #{elapsed} seconds."
#}
#set :slack_deploy_starting_text, -> {
#  "#{fetch(:stage)} deploy starting with revision/branch #{fetch(:current_revision, fetch(:branch))} for #{fetch(:application)}"
#}
#set :slack_deploy_failed_text, -> {
#  "#{fetch(:stage)} deploy of #{fetch(:application)} with revision/branch #{fetch(:current_revision, fetch(:branch))} failed"
#}
#set :slack_deploy_finished_color, 'good'
#set :slack_deploy_failed_color, 'danger'
#set :slack_notify_events, [:started, :finished, :failed]
