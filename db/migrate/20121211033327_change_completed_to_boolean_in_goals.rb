class ChangeCompletedToBooleanInGoals < ActiveRecord::Migration
  def up
    change_column :goals, :completed, :boolean, :default => false
  end

  def down
    change_column :goals, :completed, :integer
  end
end
