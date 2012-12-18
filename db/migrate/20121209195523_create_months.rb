class CreateMonths < ActiveRecord::Migration
  def change
    create_table :months do |t|
      t.references :user
      t.timestamps
    end
    add_index :months, :user_id
  end
end