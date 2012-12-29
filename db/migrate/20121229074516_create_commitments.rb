class CreateCommitments < ActiveRecord::Migration
  def change
    create_table :commitments do |t|
      t.integer :user_id
      t.integer :goal_id
      t.boolean :is_current
      t.boolean :completed
      t.datetime :completed_at

      t.timestamps
    end
  end
end
