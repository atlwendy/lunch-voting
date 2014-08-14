class Meeting < ActiveRecord::Base
  has_many :meeting_memberships
  has_many :users, :through => :meeting_memberships, :autosave=>false
  has_many :meeting_restaurant_selections
  has_many :restaurants, :through => :meeting_restaurant_selections

  scope :future_meetings, lambda { where('DATE(date) > ?', Date.today)}

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
    return userstatus
    #ust = userstatus.sort_by{|key, value| value}.reverse
  end

end
