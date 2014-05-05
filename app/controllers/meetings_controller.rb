class MeetingsController < ApplicationController
  before_action :set_meeting, only: [:show, :edit, :update, :destroy]

  # GET /meetings
  # GET /meetings.json
  def index
    @meetings = Meeting.all.order('date')
  end

  # GET /meetings/1
  # GET /meetings/1.json
  def show
    @meeting_id = params[:id] #if I don't have this, I get error message as:
                              #Parameters: {"uid"=>"4", "mrs_id"=>"14", "vote"=>"up", "id"=>"updateVoteDB"}
                              #Meeting Load (0.2ms)  SELECT  "meetings".* FROM "meetings"  WHERE "meetings"."id" = ? LIMIT 1  [["id", 0]]
                              #Completed 404 Not Found in 3ms

                              #ActiveRecord::RecordNotFound (Couldn't find Meeting with 'id'=updateVoteDB):
                              #app/controllers/meetings_controller.rb:159:in `set_meeting'
    @user = params[:user]
    @uid = User.where('email = ?', @user).first.id
    mrs = MeetingRestaurantSelection.where('meeting_id = ?', params[:id])
    @mrs_id = mrs.empty? ? 0 : mrs.first.id
    @votes = getVotes(params[:id], params[:user])
  end

  # GET /meetings/new
  def new
    @meeting = Meeting.new
  end

  # GET /meetings/1/edit
  def edit
  end

  # POST /meetings
  # POST /meetings.json
  def create
    @meeting = Meeting.new(meeting_params)
    users = getUsers(params[:emailaddress])
    restaurants = getRest(params[:restaurantname])
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

  def getVotes(meeting_id, user)
    restaurants = Meeting.find(meeting_id).restaurants
    mrs = MeetingRestaurantSelection.where('meeting_id = ?', meeting_id)
    uid = User.find_by_email(user).id
    return 0 if mrs.empty?
    votes = 0
    mrs.each do |mm|
      umv = UserMrsVotecounts.where('user_id = ? AND mrs_id = ?', uid, mm.id)
      next if umv.empty?
      votes = votes + umv.vote_counts
    end
    return votes
  end

  def updateUMVdb
    uid = params[:uid]
    mrs_id = params[:mrs_id]
    vote = params[:vote] == 'up' ? 1 : -1
    id = params[:id]
    umv = UserMrsVotecounts.where('user_id = ? AND mrs_id = ?', uid, mrs_id)
    if umv.empty?
      umv = UserMrsVotecounts.new(:user_id=>uid, :mrs_id=>mrs_id, :vote_counts=>1)
    else
      umv.vote_counts = umv.first.vote_counts.to_i + vote
    end
    umv.save
  end

  def getUsers(emails)
    return [] if emails.nil?
    users = []
    emails.each do |e|
      u = User.where({email: e})
      u = u.empty? ? User.new(:email=>e, :username=>e) : u.first
      users.push(u)
    end
    return users
  end

  def getRest(rest)
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
    users = getUsers(params[:emailaddress])
    restaurants = getRest(params[:restaurantname])
    @meeting.users = users + @meeting.users
    @meeting.restaurants = restaurants + @meeting.restaurants
    logger.info("$$$$$$$$$$$$$$$$$$$$$$$$")
    @meeting.users.each do |u|
      logger.info(u.email)
    end
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
  end

  def submit_members
    meeting = Meeting.find(params[:id])
    meeting.users = User.where({id: params[:user_id]})
    redirect_to meeting
  end
  
  def select_restaurants
    @meeting = Meeting.find(params[:id])
    @restaurants = @meeting.restaurants
    @allrests = Restaurant.all
  end

  def submit_restaurants
    meeting = Meeting.find(params[:id])
    meeting.restaurants = Restaurant.where({id: params[:restaurant_id]})
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
