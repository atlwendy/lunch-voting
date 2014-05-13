class MeetingRestaurantSelection < ActiveRecord::Base
  belongs_to  	:meeting
  belongs_to  	:restaurant
  has_many		:votes

  def vote_count
  	votes.reduce(0) {|sum, vote| sum + vote.vote_counts }
  end
end
