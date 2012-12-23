class Month < ActiveRecord::Base
    belongs_to :user
    has_many :goalsinmonths
    has_many :goals, :through => :goalsinmonths, :uniq => true

    attr_accessible :user_id

    validates :user_id, presence: true



    def add_goal (goal)

        if goal && !self.goals.include?(goal)
            self.goals << goal
        end

        # Adding descendants to month
        for d in goal.descendants
            unless self.goals.include?(d)
                self.goals << d
            end
        end
        
    end

end
