class Commitment < ActiveRecord::Base
    belongs_to :goal
    belongs_to :user

    attr_accessible :completed, :completed_at, :goal_id, :is_current, :user_id, :created_at

    validates_uniqueness_of :goal_id, :scope => :user_id
    validates :user_id, presence: true
    validates :goal_id, presence: true

end
