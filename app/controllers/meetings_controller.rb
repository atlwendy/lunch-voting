class MeetingsController < ApplicationController
  before_action :set_meeting, only: [:show, :edit, :update, :destroy]

  def index
    @meetings = Meeting.all.order('date')
  end

  def show
    @meeting_id = params[:id] 
    @meeting = Meeting.find(@meeting_id)
    @user = current_user
    @uid = @user.nil? ? 0 : User.where('email = ?', @user.email).first.id
    logger.info("$$$$$$$$$$$$$$$UID$$$$$$$$$")
    logger.info(@uid)
    mrs = MeetingRestaurantSelection.where('meeting_id = ?', params[:id])
    @inGroup = is_user_invited?(@user.email, @meeting_id)
  end

  def get_all_restaurants(meeting)
    meeting_mrs = Hash.new
    rests = meeting.restaurants
    rests.each do |r|
      mrs_id = MeetingRestaurantSelection.where('meeting_id = ? AND restaurant_id = ?', meeting.id, r.id).first.id
      votes = get_votes(mrs_id)
      if votes == 0
        upordown = nil
      elsif votes > 0
        upordown = 'up'
      else
        upordown = 'down'
      end
      meeting_mrs[r] = [get_votes(mrs_id), mrs_id, upordown]
    end
    return meeting_mrs
  end

  def new
    @meeting = Meeting.new
  end

  def edit
  end

  def create
    @meeting = Meeting.new(meeting_params)
    users = get_users(params[:emailaddress])
    restaurants = get_restaurant(params[:restaurantname])
    @meeting.users = users
    @meeting.restaurants = restaurants
    respond_to do |format|
      if @meeting.save
        format.html { redirect_to @meeting, notice: 'Meeting was successfully created.' }
        format.json { render :show, status: :created, location: @meeting }
        UserMailer.invite(users, meeting_url(@meeting)).deliver
      else
        format.html { render :new }
        format.json { render json: @meeting.errors, status: :unprocessable_entity }
      end
    end
  end

  def is_user_invited?(user, mid)
    return Meeting.find(mid).users.include?(User.find_by_email(user)) ? true : false
  end

  def get_votes(mrs_id)
    votes = 0
    umvs = Vote.where('meeting_restaurant_selection_id = ?', mrs_id)
    return umvs.empty? ? 0 : umvs.map{|x| votes=votes+x.vote_counts}[0]
  end

  def update_vote
    uid = params[:uid]
    mrs_id = params[:mrs_id]
    vote = params[:vote] == 'up' ? 1 : -1
    id = params[:id]
    umv = Vote.where('user_id = ? AND meeting_restaurant_selection_id = ?', uid, mrs_id).first
    if umv.nil?
      umv = Vote.new(:user_id=>uid, :meeting_restaurant_selection_id=>mrs_id, :vote_counts=>1)
    else
      umv.vote_counts = umv.vote_counts.to_i + vote
    end
    umv.save
  end

  def get_users(emails)
    return [] if emails.nil?
    users = []
    emails.each do |e|
      u = User.where({email: e})
      u = u.empty? ? User.new(:email=>e, :username=>e, :password=>"lunchvoting") : u.first
      users.push(u)
    end
    return users
  end

  def get_restaurant(rest)
    return [] if rest.nil?
    rests = []
    rest.each do |r|
      rr = Restaurant.where({name: r})
      rr = rr.empty? ? Restaurant.new(:name=>r) : rr.first
      rests.push(rr)
    end
    return rests
  end


  # PATCH/PUT /meetings/1
  # PATCH/PUT /meetings/1.json
  def update
    users = get_users(params[:emailaddress])
    restaurants = get_restaurant(params[:restaurantname])
    @meeting.users = users + @meeting.users
    @meeting.restaurants = restaurants + @meeting.restaurants
   
    respond_to do |format|
      if @meeting.update(meeting_params)  
        UserMailer.meeting_update(@meeting.users, meeting_url(@meeting)).deliver      
        format.html { redirect_to @meeting, notice: 'Meeting was successfully updated.' }
        format.json { render :show, status: :ok, location: @meeting }
      else
        format.html { render :edit }
        format.json { render json: @meeting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meetings/1
  # DELETE /meetings/1.json
  def destroy
    @meeting.destroy
    respond_to do |format|
      format.html { redirect_to meetings_url }
      format.json { head :no_content }
    end
  end

  def select_members
    @meeting = Meeting.find(params[:id])
    @users = @meeting.users
    @allusers = User.all
    @alluseremails = User.pluck(:email) #get_user_emails(@allusers)
  end

  def submit_members
    meeting = Meeting.find(params[:id])
    meeting.users = User.where({id: params[:user_id]}) + get_users(params[:emailaddress])
    redirect_to meeting
  end
  
  def select_restaurants
    @meeting = Meeting.find(params[:id])
    @restaurants = @meeting.restaurants
    @allrests = Restaurant.all
    @all_restaurant_names = Restaurant.pluck(:name)
  end

  def submit_restaurants
    meeting = Meeting.find(params[:id])
    meeting.restaurants = Restaurant.where({id: params[:restaurant_id]}) + get_restaurant(params[:restaurantname])
    redirect_to meeting
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meeting
      @meeting = Meeting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def meeting_params
      params.require(:meeting).permit(:title, :description, :date)
    end
end
