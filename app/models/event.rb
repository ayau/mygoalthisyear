class Event < ActiveRecord::Base
    belongs_to :user
    belongs_to :goal
  
    attr_accessible :user_id, :goal_id

    validates_presence_of :user_id, :goal_id
end
