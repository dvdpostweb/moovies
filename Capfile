load 'deploy'
# Uncomment if you are using Rails' asset pipeline

load 'config/deploy' # remove this line to skip loading any of the default tasks

require 'capistrano-slack-notify'

set :slack_webhook_url,   "https://hooks.slack.com/services/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"

before 'deploy', 'slack:starting'
after  'deploy', 'slack:finished'
before 'deploy:rollback', 'slack:failed'