# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron
env :PATH, '/opt/ruby-1.9.3-p448/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/opt/ruby/bin::/opt/ruby/bin:'
# Example:
#
# set :output, "/path/to/my/cron_log.log"
set :output, './log/cron.log'
#
 every 30.minutes do
#   command "/usr/bin/some_great_command"
   runner "Product.update_package"
#   rake "some:great:rake:task"
 end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end
every 1.day, :at => '0:20 am' do  
  rake "ts:index"  
end
every 1.day, :at => '11:20 am' do  
  rake "ts:index"  
end
every 1.day, :at => '5:20 pm' do  
  rake "ts:index"  
end

#every 1.day, :at => '0:35 am' do  
#  runner "Product.get_product_home"  
#end
every 1.day, :at => '11:55 am' do  
  runner "Product.get_product_home_adult"  
end

# Learn more: http://github.com/javan/whenever
