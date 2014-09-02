include Yelp::V1::Review::Request
class MeetingsController < ApplicationController
  before_action :login_required
  before_action :set_meeting, only: [:show, :edit, :update, :destroy]

  layout 'menu'
  
  def index
    meetings = []
    @meetings = Meeting.aggregate_meeting_by_date(Meeting.all.order('date').reverse.each{|x| meetings.push(x) if x.users.include?(current_user)})
  end

  def show
    @meeting_id = params[:id] 
    @meeting = Meeting.find(@meeting_id)
    @user = current_user
    @uid = @user.nil? ? 0 : User.where('email = ?', @user.email).first.id
    @going = Meeting.usergoing(@uid, @meeting_id)
    mrs = MeetingRestaurantSelection.where('meeting_id = ?', params[:id])
    @meeting_mrs = @meeting.meeting_restaurant_selections.sort_by{|x| [x.vote_count, x['name']]}.reverse
    @inGroup = is_user_invited_and_confirmed?(@user, @meeting_id)
    @userlist = Meeting.userstatus(@meeting_id)
    @statuscounts = Meeting.statuscounts(@userlist)
    @result_sent = @meeting.result_sent
    @winner = Restaurant.find_by_id(Meeting.pick_winner(@meeting))
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
    @id = Meeting.all.empty? ? 1 : Meeting.maximum("id") + 1
    @new = true
  end

  def edit
    @id = params[:id]
    @new = false
  end

  def create
    @meeting = Meeting.new(meeting_params)
    tid = ActiveRecord::Base.connection.execute "select last_value from meetings_id_seq"
    id = tid[0]['last_value'].to_i + 1
    users = get_users(params[:emailaddress], id)
    rn = params[:restaurant_name]
    input_restaurants = get_restaurant(params[:restaurantname])
    restaurants = rn.nil? ? input_restaurants :  input_restaurants + add_default_restaurants(rn)
    @meeting.users = users.push(current_user)
    @meeting.restaurants = restaurants
    respond_to do |format|
      if @meeting.save
        MeetingMembership.where('meeting_id = ? and user_id = ?', Meeting.maximum('id'), current_user.id).first.update_attributes(:going=>"Yes")
        @meeting.users.each do |u|  
          UserMailer.invite(u, meeting_url(@meeting)).deliver      
        end
        format.html { redirect_to @meeting, notice: 'Meeting was successfully created.' }
        format.json { render :show, status: :created, location: @meeting }
        
      else
        format.html { render :new }
        format.json { render json: @meeting.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_default_restaurants(restaurants)
    return [] if restaurants.nil?
    r = []
    restaurants.each do |rx|
      rr = eval(rx.gsub(":", "=>"))
      rt = Restaurant.where("lower(name)=?", rr['name'].downcase).first
      if rt.nil?
        cr = Restaurant.new
        cr['name'] = rr['name']
        cr['address'] = rr['address']
        cr['url'] = rr['url'].gsub("=>", ":")
        cr['photo_url'] = rr['photo_url'].gsub("=>", ":")
        cr['yelp_rating'] = rr['rating']
        cr.save
        r.push(cr)
      else
        r.push(rt) unless r.include?(rt)
      end
    end
    return r
  end


  def is_user_invited_and_confirmed?(user, mid)
    invited = Meeting.find(mid).users.include?(user) ? true : false
    status = Meeting.usergoing(user.id, mid)
    return false if status.nil?
    confirmed = status.include?('Y') ? true : false unless invited.blank?
    return invited & confirmed
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
      umv = Vote.new(:user_id=>uid, :meeting_restaurant_selection_id=>mrs_id, :vote_counts=>vote)
    else
      umv.vote_counts = umv.vote_counts.to_i + vote
    end
    umv.save
    meeting_mrs = Meeting.find(id).meeting_restaurant_selections.sort_by{|x| x.vote_count}.reverse
    render :partial=>"restaurant_list", :locals=>{:meeting_mrs=>meeting_mrs, :uid=>uid} 
  end

  def set_decision
    uid = params[:uid]
    id = params[:id]
    decision = params[:decision]
    mmembership = MeetingMembership.where('user_id = ? AND meeting_id = ?', uid, id).first
    mmembership.going = decision
    mmembership.save
  end

  def get_users(emails, id=0)
    return [] if emails.nil?
    users = []
    emails.each do |e|
      u = User.where({email: e})
      if u.empty?
        # send invitation
        invite = Invitation.new(:recipient_email=>e, :sender_id=>id)
        invite.save
        InvitationMailer.send_invitation(current_user, invite, signup_url,invite.token).deliver
      else
        users.push(u.first) unless users.include?(u.first)
      end
      #u = u.empty? ? User.new(:email=>e, :username=>e) : u.first
      #users.push(u) if not users.include?(u)
    end
    return users
  end

  def get_restaurant(rest, yelp=false)
    return [] if rest.nil?
    rests = []
    rest.each do |r|
      rname = yelp ? r['name'] : r
      rr = Restaurant.where("lower(name)=?", rname.downcase)
      rr = rr.empty? ? Restaurant.new(:name=>rname) : rr.first
      rests.push(rr) unless rests.include?(rr)
    end
    return rests
  end

  def get_default_restaurants
    client = Yelp::Client.new
    
    request = GeoPoint.new(
             :term => "restaurants",
             :latitude => params[:lati],
             :longitude => params[:longi]
              )
    response = client.search(request)
    
    render json: parse_restaurant_list(response).to_json
  end

  def search_restaurants_from_input_address
    client = Yelp::Client.new
    
    request = Location.new(
      :address => params[:address],
      :city => params[:city],
      :state => params[:state],
      :zipcode => params[:zipcode],
      :radius => 5,
      :term => "restaurants" )
    response = client.search(request)
    render json: parse_restaurant_list(response).to_json
  end

  def parse_restaurant_list(response)
    return [response['message']['text']] if response['businesses'].empty?
    @defaultrests = []
    response['businesses'].each do |business|
      info = Hash.new
      info['name'] = business['name'].gsub("'", "")
      info['distance'] = business['distance']
      info['is_closed'] = business['is_closed']
      info['rating'] = business['avg_rating']
      info['url'] = business['url']
      info['address'] = business['address1'] + business['address2'] + business['address3'] + ', ' + business['city'] + ', ' + ', ' + business['state'] + ' ' + business['zip']
      info['photo_url'] = business['photo_url']
      @defaultrests.push(info)
    end
    @defaultrests.sort_by!{|x| x['distance']}
    return @defaultrests
  end

  
  def update
    users = get_users(params[:emailaddress], params[:id])
    restaurants = get_restaurant(params[:restaurantname])
    @meeting.users = users + @meeting.users
    @meeting.restaurants = restaurants + @meeting.restaurants
    @new = false
    
    respond_to do |format|
      if @meeting.update(meeting_params)
        @meeting.users.each do |u|  
          UserMailer.meeting_update(u, meeting_url(@meeting)).deliver      
        end
        format.html { redirect_to @meeting, notice: 'Meeting was successfully updated.' }
        format.json { render :show, status: :ok, location: @meeting }
      else
        format.html { render :edit }
        format.json { render json: @meeting.errors, status: :unprocessable_entity }
      end
    end
  end

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
    @allusers = []
    User.all.order('username').each{|x| @allusers.push(x) if not (x.meetings & current_user.meetings).empty?}
    @alluseremails = @users.pluck(:email) #get_user_emails(@allusers)
    # @alluseremails = []
    # @alluseremails = @allusers.map{|x| @alluseremails.push(x.email)}
  end

  def submit_members
    meeting = Meeting.find(params[:id])
    send_updates(meeting.users.pluck(:id), params[:user_id], meeting)
    meeting.users = meeting.users + get_users(params[:emailaddress], params[:id])
    redirect_to meeting
  end

  def send_updates(old_ids, new_ids, meeting)
    return if new_ids.nil?
    newadded = new_ids.collect{|x| x.to_i} - old_ids
    return if newadded.empty?
    url = meeting_path(meeting)
    newadded.each{|x| UserMailer.newlyadded_members(url, x, current_user).deliver}
  end
  
  def select_restaurants
    @id = params[:id]
    @meeting = Meeting.find(@id)
    @restaurants = @meeting.restaurants
    @allrests = Restaurant.all
    @all_restaurant_names = Restaurant.pluck(:name)
  end

  def submit_restaurants
    meeting = Meeting.find(params[:id])
    meeting.restaurants = Restaurant.where({id: params[:restaurant_id]}) + add_default_restaurants(params[:restaurant_name]) + get_restaurant(params[:restaurantname], false)
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
