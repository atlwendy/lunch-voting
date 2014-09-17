class Meeting < ActiveRecord::Base
  has_many :meeting_memberships
  has_many :users, :through => :meeting_memberships, :autosave=>false
  has_many :meeting_restaurant_selections
  has_many :restaurants, :through => :meeting_restaurant_selections

  scope :future_meetings, lambda { where('DATE(date) >= ?', Date.today)}
  before_save :capitalize_title
  validates_presence_of :title, :message => "cannot be empty"
  validate :meeting_date_after_today

  def meeting_date_after_today
    if self.date < Time.now
      errors.add(:meeting, 'lunch date needs to be after current time')
    end
  end

  def capitalize_title
    self.title = self.title.split.map(&:capitalize).join(' ') unless self.title.blank?
  end

  def restaurants_attributes=(hash)
    hash.each do |sequence,restaurant_values|
      restaurants <<  Restaurant.find_or_create_by_name_and_url(restaurant_values[:name],\
        restaurant_values[:url])
    end
  end

  def self.usergoing(uid, mid)
    mm = MeetingMembership.where('user_id = ? AND meeting_id = ?', uid, mid)
    if mm.blank?
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
    return 0 if restaurant_votes.empty? or restaurant_votes.max_by{|k,v| v}[1].to_i == 0
    hv_pair = restaurant_votes.select{|k, v| v == restaurant_votes.values.max}
    rid_highest_votes = hv_pair.reduce({}){|h,(k,v)| (h[v] ||= []) << k;h}.max[1]
    rid_yelp_review = Hash.new
    rid_highest_votes.each{|x| rid_yelp_review[x] = 
        [Restaurant.find_by_id(x).yelp_rating, Restaurant.find_by_id(x).review_count] }
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

  def self.aggregate_meeting_by_date(meetings)
    aggregated_meetings = {}
    meetings.each do |m|
      mdate = m.date.to_date
      if aggregated_meetings[mdate].blank?
        aggregated_meetings[mdate] = [m]
      else
        aggregated_meetings[mdate].push(m)
      end
    end
    aggregated_meetings
  end
end
