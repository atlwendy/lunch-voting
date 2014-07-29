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
end
