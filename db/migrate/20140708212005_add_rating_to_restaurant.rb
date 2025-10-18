class AddRatingToRestaurant < ActiveRecord::Migration[7.1]
  def change
    add_column :restaurants, :yelp_rating, :string
  end
end
