class AddReviewCountToRestaurant < ActiveRecord::Migration[7.1]
  def change
    add_column :restaurants, :review_count, :integer, :default=>0
  end
end
