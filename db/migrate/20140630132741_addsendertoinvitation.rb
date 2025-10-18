class Addsendertoinvitation < ActiveRecord::Migration[7.1]
  def change
  	add_column :invitations, :sender_id, :integer
  end
end
