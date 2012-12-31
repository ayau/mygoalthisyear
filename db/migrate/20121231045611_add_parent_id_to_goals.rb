class AddParentIdToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :parent_id, :integer, :default => 0
  end
end
