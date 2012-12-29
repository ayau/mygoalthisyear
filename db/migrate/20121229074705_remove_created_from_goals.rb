class RemoveCreatedFromGoals < ActiveRecord::Migration
  def up
    remove_column :goals, :completed
    remove_column :goals, :completed_at
    change_column :commitments, :completed, :boolean, :default => false
  end

  def down
  end
end
