class Meeting < ActiveRecord::Base
  has_many :meeting_memberships
  has_many :users, :through => :meeting_memberships, :autosave=>false
  has_many :meeting_restaurant_selections
  has_many :restaurants, :through => :meeting_restaurant_selections

  scope :future_meetings, lambda { where('DATE(date) >= ?', Date.today)}

  def restaurants_attributes=(hash)
    hash.each do |sequence,restaurant_values|
      restaurants <<  Restaurant.find_or_create_by_name_and_url(restaurant_values[:name],\
        restaurant_values[:url])
    end
  end

  def self.usergoing(uid, mid)
    mm = MeetingMembership.where('user_id = ? AND meeting_id = ?', uid, mid)
    if mm.empty?
      return 'nothing'
    else
      return mm.first.going
    end
  end

  def self.userstatus(mid)
    userstatus = Hash.new
    meeting = Meeting.find_by_id(mid)
    meeting.users.sort_by{|x| x.username}.each do |user|
      going = usergoing(user.id, mid) || ''
      userstatus[user.username] = going
    end
    return Hash[userstatus.sort]
    #return userstatus
    # ust = userstatus.sort_by{|key, value| value}.reverse
  end

  def self.rsvpYuser(m, selection)
    ust = userstatus(m.id)
    ust.map{|key, _| key if ust[key]==("#{selection}")}.compact
  end

  def self.statuscounts(status)   
    status.each_with_object(Hash.new{|h, k| h[k] = '0'}) do |k, res|
      res[k[1]].succ!
    end
  end

  def self.check_and_send_reminder()
    Meeting.future_meetings.each do |m|
      if m.date - Time.now < 172800 and not m.reminder_sent
        ReminderMailer.send_reminder(m).deliver
        m.update_attributes(:reminder_sent=>true)
      end
    end
  end

  def self.pick_winner(m)
    restaurant_votes = Hash.new
    m.meeting_restaurant_selections.each{|y| restaurant_votes[y.restaurant_id] = y.vote_count}
    return 0 if restaurant_votes.empty?
    hv_pair = restaurant_votes.select{|k, v| v == restaurant_votes.values.max}
    rid_highest_votes = hv_pair.reduce({}){|h,(k,v)| (h[v] ||= []) << k;h}.max[1]
    rid_yelp_review = Hash.new
    rid_highest_votes.each{|x| rid_yelp_review[x] = Restaurant.find_by_id(x).yelp_rating}
    return rid_yelp_review.max_by{|k, v| v}[0]
  end

  def self.send_winner_restaurant()
    Meeting.future_meetings.each do |m|
      if m.date - Time.now <= 86410 and not m.result_sent
        ReminderMailer.send_result(m).deliver
        m.update_attributes(:result_sent=>true)
      end
    end
  end
end
