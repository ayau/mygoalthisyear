class CreateCommitments < ActiveRecord::Migration
  def change
    create_table :commitments do |t|
      t.integer :user_id
      t.integer :goal_id
      t.integer :is_current, :default => 0
      t.integer :completed, :default => 0
      t.datetime :completed_at

      t.timestamps
    end
  end
end
