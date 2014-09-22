class SessionsController < ApplicationController

	layout :define_layout
	
	def new
	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			sign_in(user)
			redirect_back_or user
		else
			flash.now[:error] = 'Invalid email/password combination' # Not quite right!
			render 'new'
		end
	end

	def destroy
		sign_out
    	redirect_to root_url
	end

	def frontpage
		return if current_user.nil?
		redirect_to :action=>'index', :controller=>'meetings'
	end

	private
	def define_layout
		action_name == 'frontpage' ? 'empty' : 'sessions'
	end

end
