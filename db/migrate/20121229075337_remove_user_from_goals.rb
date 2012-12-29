class RemoveUserFromGoals < ActiveRecord::Migration
  def up
        remove_column :goals, :user_id
        add_column :goals, :owner_id, :integer
        add_index :goals, :owner_id
  end

  def down
  end
end
