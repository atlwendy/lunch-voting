class AddTitleRequiredMeeting < ActiveRecord::Migration[7.1]
  def change
    change_column :meetings,  :title, :string, :null=>false
  end
end
