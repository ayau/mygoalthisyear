class ChangeCreatedAtToNotNull < ActiveRecord::Migration
  def up
    change_column :goals, :completed_at, :datetime, :null => false, :default => Time.now
  end

  def down
  end
end
