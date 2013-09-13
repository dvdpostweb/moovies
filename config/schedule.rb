# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

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
  rake "thinking_sphinx:index"  
end
every 1.day, :at => '11:20 am' do  
  rake "thinking_sphinx:index"  
end
every 1.day, :at => '5:20 pm' do  
  rake "thinking_sphinx:index"  
end

every '* 8,9,10,11,12,13,14,15,16,17,18 * * 1,2,3,4,5' do
  runner "Product.update_plush"
end
every 1.day, :at => '0:05 am' do
  runner "Product.update_plush"
end
#every 1.day, :at => '0:35 am' do  
#  runner "Product.get_product_home"  
#end

# Learn more: http://github.com/javan/whenever
