class InvitationMailer < ActionMailer::Base
  default from: "invite@lunch-voting.com"

  def send_invitation(current_user, invitation, signup_url, token)
  	@signup_url = signup_url + "?invitation_token=" + token
  	@current_user = current_user
  	@invitation = invitation
    mail(to: invitation.recipient_email, subject: 'Invite to join in lunch voting')
  end
end
