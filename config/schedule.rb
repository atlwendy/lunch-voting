every 4.hours do
  #rake "send_reminder_email"
  rake "send_reminder_email --trace 2>&1" # >> #{Rails.root}/log/rake.log &"
  rake "send_result_email --trace 2>&1"
end