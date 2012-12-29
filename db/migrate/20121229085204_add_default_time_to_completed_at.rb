class AddDefaultTimeToCompletedAt < ActiveRecord::Migration
  def change
    change_column :commitments, :completed_at, :datetime, :default => Time.now
  end
end
