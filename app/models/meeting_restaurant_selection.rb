class MeetingRestaurantSelection < ActiveRecord::Base
  belongs_to  :meeting
  belongs_to  :restaurant
end
