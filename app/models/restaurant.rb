class Restaurant < ActiveRecord::Base
  has_many :meeting_restaurant_selections
  has_many :meetings, :through => :meeting_restaurant_selections
end
