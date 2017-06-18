workers Integer(ENV['WEB_CONCURRENCY'])
threads_count = Integer(ENV['MAX_THREADS'])
threads threads_count, threads_count
preload_app!
rackup      DefaultRackup
port        ENV['PORT']
environment ENV['RACK_ENV']
on_worker_boot do
  ActiveRecord::Base.establish_connection
end