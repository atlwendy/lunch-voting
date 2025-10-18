class RenameVotesColumnMrsIdToMeetingRestaurantSelectionId < ActiveRecord::Migration[7.1]
  def change
  	rename_column	:votes, :mrs_id, :meeting_restaurant_selection_id
  end
end
