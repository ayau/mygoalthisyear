class Event < ActiveRecord::Base
    belongs_to :user
    belongs_to :goal
  
    attr_accessible :user_id, :goal_id, :post

    validates_presence_of :user_id, :goal_id


    # Permissions
    def self.listable_by?(user)
        # no one can see list of events
        false
    end

    def creatable_by?(user)
        #can only create if you are commited to the goal
        !user.nil? && !Commitment.find_by_user_id_and_goal_id(user.id, self.goal_id).nil?
    end

    def destroyable_by?(user)
        self.user_id == user.id
    end

    def updatable_by?(user)
        self.user_id == user.id
    end

    def viewable_by?(user)
        # Can be viewed by anyone sharing the same goal
        !user.nil? && !Commitment.find_by_user_id_and_goal_id(user.id, self.goal_id).nil?
    end

    def owned_by?(user)
        user = self.user_id
    end


end
