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
    #restaurants = getRest(params[:restaurant])
    @meeting.users = users
    #@meeting.restaurants = restaurants
    respond_to do |format|
      if @meeting.save
        format.html { redirect_to @meeting, notice: 'Meeting was successfully created.' }
        format.json { render :show, status: :created, location: @meeting }
      else
        format.html { render :new }
        format.json { render json: @meeting.errors, status: :unprocessable_entity }
      end
    end
  end

  def getUsers(emails)
    users = []
    emails.each do |e|
      u = User.where({email: e})
      u = u.empty? ? User.new(:email=>e, :username=>e) : u.first
      users.push(u)
    end
    return users
  end

  def getRest(rest)
    rests = []
    rest.each do |r|
      r = Restaurant.where({name: r})
      r = r.empty? ? Restaurant.new(:name=>r) : r.first
      rests.push(r)
    end
    return rests
  end


  # PATCH/PUT /meetings/1
  # PATCH/PUT /meetings/1.json
  def update
    respond_to do |format|
      if @meeting.update(meeting_params)
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
    @allrestaurants = Restaurant.all
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
