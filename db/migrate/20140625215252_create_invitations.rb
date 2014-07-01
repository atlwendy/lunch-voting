class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :recipient_email
      t.string :string
      t.string :token

      t.timestamps
    end
  end
end
