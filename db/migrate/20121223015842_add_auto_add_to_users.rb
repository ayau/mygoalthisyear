class AddAutoAddToUsers < ActiveRecord::Migration
  def change
    add_column :users, :auto_add, :integer, :default => 0
  end
end
