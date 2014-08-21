every 1.day, :at=>"5:00am" do
  #rake "send_reminder_email"
  rake "send_reminder_email --trace 2>&1" # >> #{Rails.root}/log/rake.log &"
end