class AddInvitationToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :invitation_id, :integer
  end
end
