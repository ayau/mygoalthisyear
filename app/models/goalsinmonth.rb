class Goalsinmonth < ActiveRecord::Base
    belongs_to :goal
    belongs_to :month

    validates_uniqueness_of :goal_id, :scope => :month_id
end
