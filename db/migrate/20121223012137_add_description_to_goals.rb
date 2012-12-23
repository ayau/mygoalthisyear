class AddDescriptionToGoals < ActiveRecord::Migration
  def up
    add_column :goals, :description, :text, :default => ""
    add_column :goals, :deadline, :date
    add_column :goals, :has_deadline, :boolean, :default => false
  end
  def down
    remove_column :goals, :description
    remove_column :goals, :deadline
    remove_column :goals, :has_deadline
  end
end
