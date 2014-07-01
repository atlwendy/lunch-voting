class Addsendertoinvitation < ActiveRecord::Migration
  def change
  	add_column :invitations, :sender_id, :integer
  end
end
