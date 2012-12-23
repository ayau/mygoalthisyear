class AddPostToEvents < ActiveRecord::Migration
    def up
        add_column :events, :post, :text, :default => ""
    end
    def down
        remove_column :events, :post
    end
end
