class Addcolumntorestaurant < ActiveRecord::Migration
  def change
  	add_column	:restaurants, :photo_url,	:string
  end
end
