class AddInvitationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :invitation_id, :integer
  end
end
