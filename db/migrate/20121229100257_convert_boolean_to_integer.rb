class ConvertBooleanToInteger < ActiveRecord::Migration
  def up
    change_column :commitments, :completed, :integer, :default => 0
    change_column :commitments, :is_current, :integer
    change_column :goals, :has_deadline, :integer, :default => 0
    change_column :users, :auto_add, :integer, :default => 0
  end

  def down
  end
end
