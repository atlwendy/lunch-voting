class AddRatingToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :yelp_rating, :string
  end
end
