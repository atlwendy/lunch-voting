class AddCategoriesToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :categories, :string
  end
end
