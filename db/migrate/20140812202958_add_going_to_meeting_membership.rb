class AddGoingToMeetingMembership < ActiveRecord::Migration[7.1]
  def change
    add_column :meeting_memberships, :going, :string, :limit=>10
  end
end
