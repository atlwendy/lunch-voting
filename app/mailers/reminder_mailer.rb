class ReminderMailer < ActionMailer::Base
  default from: "reminder@lunch-tvoting.com"

  def send_reminder(m)
    @meeting = m
    allYusers = Meeting.rsvpYuser(m, 'Yes')
    allYusers.each do |k|
      @user = User.find_by_username(k)
      @allusers = allYusers - [@user.username]
      mail(to: @user.email, subject: 'Lunch Voting Reminder')
    end
  end

  def send_result(m)
    @meeting = m
    allYusers = Meeting.rsvpYuser(m, 'Yes')
    @winner = Restaurant.find_by_id(Meeting.pick_winner(m)).name
    allYusers.each do |mu|
      @user = User.find_by_username(mu)
      @allusers = allYusers - [@user.username]
      mail(to: @user.email, subject: 'Your Lunch Restaurant Winner')
    end
  end

end
