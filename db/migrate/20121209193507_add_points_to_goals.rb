class AddPointsToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :points, :integer, :default => 0
  end
end
