class UserMailer < ActionMailer::Base
  default from: "invite_notify@lunchvoting.com"

  def invite(users, url)
  	@url = url
  	users.each do |u|
  		@user = u.email
  		mail(to: @user, subject: 'Invite to join in lunch voting')
  	end
  end

  def meeting_update(users, url)
  	@url = url
  	users.each do |u|
  		@user = u.email
  		mail(to: @user, subject: 'Update to the lunch')
  	end
  end
end
