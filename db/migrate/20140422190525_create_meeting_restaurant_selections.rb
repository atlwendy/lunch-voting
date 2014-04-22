class CreateMeetingRestaurantSelections < ActiveRecord::Migration
  def change
    create_table :meeting_restaurant_selections do |t|
      t.integer :meeting_id
      t.integer :restaurant_id

      t.timestamps
    end
  end
end
