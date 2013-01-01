class AddAvatarToUsers < ActiveRecord::Migration
    def up
        add_column :users, :avatar, :text
        add_column :users, :timezone, :string
    end
    def down
        remove_column :users, :avatar
        remove_column :users, :timezone
    end
end
