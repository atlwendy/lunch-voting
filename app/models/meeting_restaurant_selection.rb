class MeetingRestaurantSelection < ActiveRecord::Base
  belongs_to  	:meeting
  belongs_to  	:restaurant
  has_many		:votes
end
