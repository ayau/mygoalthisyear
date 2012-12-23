class AddAutoAddToUsers < ActiveRecord::Migration
  def change
    add_column :users, :auto_add, :boolean, :default => false
  end
end
