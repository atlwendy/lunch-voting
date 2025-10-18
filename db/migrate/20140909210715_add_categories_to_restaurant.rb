class AddCategoriesToRestaurant < ActiveRecord::Migration[7.1]
  def change
    add_column :restaurants, :categories, :string
  end
end
