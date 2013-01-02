class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :goal
      t.references :user
      t.integer :sender_id
      t.string :notification_type
      t.text :message
      t.integer :read, :default => 0

      t.timestamps
    end
    add_index :notifications, :goal_id
    add_index :notifications, :user_id
  end
end
