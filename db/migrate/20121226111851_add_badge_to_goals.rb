class AddBadgeToGoals < ActiveRecord::Migration
    def up
        add_column :goals, :badge, :string
        add_column :goals, :color, :string
    end
    def down
        remove_column :goals, :badge
        remove_column :goals, :color
    end
end
