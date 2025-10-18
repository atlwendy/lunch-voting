class CreateVotes < ActiveRecord::Migration[7.1]
  def change
    create_table :votes do |t|
    	t.integer       :user_id
        t.integer       :mrs_id
        t.integer       :vote_counts
        t.timestamps
    end
  end
end
