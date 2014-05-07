class MeetingRestaurantSelection < ActiveRecord::Base
  belongs_to  	:meeting
  belongs_to  	:restaurant
  has_many		:user_mrs_votecounts
end
