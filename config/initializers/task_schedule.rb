require 'rubygems'  
require 'rufus/scheduler'

scheduler = Rufus::Scheduler.start_new

scheduler.cron("* 0,8,16 * * *") do  
    `rake "send_reminder_email --trace 2>&1"`
end