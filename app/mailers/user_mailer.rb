class UserMailer < ActionMailer::Base
  default from: "invite_notify@lunchvoting.com"

  def invite(u, url)  	
  	@user = u.email
    @url = url
  	mail(to: @user, subject: 'Invite to join in lunch voting')  	
  end

  def meeting_update(u, url)
  	@url = url
  	@user = u.email
  	mail(to: @user, subject: 'Update to the lunch')
  end
end
