class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.string :name
      t.references :user
      t.integer :completed

      t.timestamps
    end
    add_index :goals, :user_id
  end
end
