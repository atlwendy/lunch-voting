class AddGoingToMeetingMembership < ActiveRecord::Migration
  def change
    add_column :meeting_memberships, :going, :string, :limit=>10
  end
end
