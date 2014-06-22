class Restaurant < ActiveRecord::Base
  has_many :meeting_restaurant_selections
  has_many :meetings, :through => :meeting_restaurant_selections

  before_save :capitalize_name, :url_add_http

  def capitalize_name
  	self.name.capitalize!
  end

  def url_add_http
  	if not self.url.include?("http")
  		self.url = "http://" + self.url
  	end
  end

end
