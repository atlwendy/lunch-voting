class User < ActiveRecord::Base
  has_many :meeting_memberships
  has_many :meetings, through: :meeting_memberships
end
