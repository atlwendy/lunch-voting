class CreateMeetings < ActiveRecord::Migration[7.1]
  def change
    create_table :meetings do |t|
      t.string :title
      t.string :description
      t.timestamp :date

      t.timestamps
    end
  end
end
