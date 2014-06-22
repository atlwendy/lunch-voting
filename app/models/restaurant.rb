class Restaurant < ActiveRecord::Base
  has_many :meeting_restaurant_selections
  has_many :meetings, :through => :meeting_restaurant_selections

  before_save :capitalize_name

  def capitalize_name
  	self.name.capitalize!
  end
end
