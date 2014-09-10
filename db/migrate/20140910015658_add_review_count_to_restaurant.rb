class AddReviewCountToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :review_count, :integer, :default=>0
  end
end
