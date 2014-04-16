class User < ActiveRecord::Base
  has_many :meetings, through: :meeting_memberships
end
