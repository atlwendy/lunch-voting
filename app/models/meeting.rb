class Meeting < ActiveRecord::Base
  has_many :meeting_memberships
  has_many :users, :through => :meeting_memberships, :autosave=>false
  has_many :meeting_restaurant_selections
  has_many :restaurants, :through => :meeting_restaurant_selections
end
