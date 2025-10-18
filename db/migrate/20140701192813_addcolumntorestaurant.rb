class Addcolumntorestaurant < ActiveRecord::Migration[7.1]
  def change
  	add_column	:restaurants, :photo_url,	:string
  end
end
