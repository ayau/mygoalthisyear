class AddAncestryToGoal < ActiveRecord::Migration
  def self.up
    add_column :goals, :ancestry, :string
    add_index :goals, :ancestry
  end
  def self.down
    remove_column :goals, :ancestry, :string
    remove_index :goals, :ancestry 
  end
end
