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

  def newlyadded_members(url, user_id, current_user)
    @url = url
    @user = User.find(user_id)
    @current_user = current_user
    mail(to: @user.email, subject: 'Invite to join in lunch voting')
  end
end
