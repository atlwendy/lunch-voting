class RenameVotesColumnMrsIdToMeetingRestaurantSelectionId < ActiveRecord::Migration
  def change
  	rename_column	:votes, :mrs_id, :meeting_restaurant_selection_id
  end
end
