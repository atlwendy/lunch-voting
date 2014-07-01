class InvitationMailer < ActionMailer::Base
  default from: "invite@lunchvoting.com"

  def send_invitation(invitation, signup_url)
  	@signup_url = signup_url
    mail(to: invitation.recipient_email, subject: 'Invite to join in lunch voting')
  end
end
