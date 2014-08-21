class AddReminderSentToMeeting < ActiveRecord::Migration
  def change
    add_column :meetings, :reminder_sent, :boolean
    add_column :meetings, :result_sent, :boolean
  end
end
