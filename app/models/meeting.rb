class Meeting < ActiveRecord::Base
  has_many :meeting_memberships
  has_many :users, :through => :meeting_memberships
end
