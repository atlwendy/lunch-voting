class UsersController < ApplicationController
  before_action :login_required, except: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  layout :resolve_layout

  def index
    @users = []
    User.all.order('username').each{|x| @users.push(x) if not (x.meetings & current_user.meetings).empty?}
    @users = @users - [current_user] if not @users.empty?
  end

  def show
    @meeting = []
    @user.meetings.each do |m|
      @meeting.push(m) if current_user.meetings.include?(m)
    end
    @meeting = @meeting.sort_by{|x| x['date']}
    @future_meetings = @meeting.reject{|x| x.date < Date.today}
    @old_meetings = Meeting.aggregate_meeting_by_date((@meeting - @future_meetings).sort_by!{|x| x['date']}.reverse)
    @next_meeting = @future_meetings.first
  end

  def new
    itken = params[:invitation_token] || @invitation_token
    if not itken.nil?
      @user = User.new(:invitation_token => itken)
      @user.email = @user.invitation.recipient_email if @user.invitation
    else
      @user = User.new
    end
  end
 
  def edit
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        sign_in @user
        if not params[:user][:invitation_token].blank?
          sid = @user.invitation.sender_id
          if sid.to_i > 0
            meeting = Meeting.find_by_id(sid)
            meeting.users.push(@user)
            meeting.save
            format.html { redirect_to meeting, notice: 'User was successfully created.'}
          else
            format.html { redirect_to @user, notice: 'User was successfully created.' }
            format.json { render :show, status: :created, location: @user }
          end
        else
          format.html { redirect_to @user, notice: 'User was successfully created.' }
          format.json { render :show, status: :created, location: @user }
        end
      else
        @invitation_token =  params[:user][:invitation_token]
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

 
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation, :invitation_token)
    end

    def resolve_layout
      case action_name
      when 'new'
        'sessions'
      else
        'menu'
      end
    end
end
