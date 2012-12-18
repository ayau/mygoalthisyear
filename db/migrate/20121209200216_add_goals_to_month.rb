class AddGoalsToMonth < ActiveRecord::Migration
    def self.up
        create_table :goalsinmonths do |t|
            t.integer :month_id
            t.integer :goal_id

            t.timestamps
        end
    end
    def self.down
        drop_table :goalsinmonths
    end
end
