class RemoveAncestry < ActiveRecord::Migration
  def up
    remove_column :goals, :ancestry
  end

  def down
  end
end
