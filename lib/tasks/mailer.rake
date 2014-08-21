desc "send reminder emails"
task :send_reminder_email => :environment do

  Meeting.check_and_send_reminder

end

desc "send result emails"
task :send_result_email => :environment do
  Meeting.send_winner_restaurant
end