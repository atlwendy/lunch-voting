class AddTitleRequiredMeeting < ActiveRecord::Migration
  def change
    change_column :meetings,  :title, :string, :null=>false
  end
end
