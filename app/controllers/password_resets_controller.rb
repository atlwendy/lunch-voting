class PasswordResetsController < ApplicationController
	layout 'menu'

  def new
  	sign_out
  end

  def create
  	user = User.find_by_email(params[:email])
    if user
      send_password_reset(user) 
      redirect_to new_password_reset_path, :notice=>"Email sent with password reset instructions"
    else
      flash[:error]="User with this email address does not exist"
      render :new
    end  	
  end

  def send_password_reset(user)
    user.generate_token(:password_reset_token)
    user.password_reset_sent_at = Time.zone.now
    user.save!
    UserMailer.password_reset(edit_password_reset_url(user.password_reset_token),user).deliver
  end

  def edit
  	sign_out
  	@user = User.find_by_password_reset_token(params[:id])
  end

  def update
  	@user = User.find_by_password_reset_token(params[:id])
  	if @user.password_reset_sent_at < 2.hours.ago
  		redirect_to new_password_reset_path, :alert=>"Password reset token expired"
  	elsif @user.update(:password=>params[:user][:password])
  		redirect_to new_session_url, :notice=>"Password has been reset. Please login with your new password"
  	else
  		render :edit
  	end
  end
end
