class UserMrsVotecounts < ActiveRecord::Base
	has_many	:users
	has_many	:meeting_restaurant_selections
	has_many	:restaurants, :through => :meeting_restaurant_selections
	has_many	:meetings,	:through => :meeting_restaurant_selections

end
