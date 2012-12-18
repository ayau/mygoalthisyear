class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :user
      t.references :goal

      t.timestamps
    end
    add_index :events, :user_id
    add_index :events, :goal_id
  end
end
