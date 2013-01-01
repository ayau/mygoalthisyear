class Goal < ActiveRecord::Base
    belongs_to :owner, :class_name => 'User', :foreign_key => 'owner_id'
    has_many :commitments

    has_many :events, :dependent => :destroy

    has_many :users, :through => :commitments, :uniq => true,
             :select => 'users.*, commitments.completed_at as completed_at,
                        commitments.completed as completed,
                        commitments.is_current as is_current'

    has_many :subgoals, :class_name => 'Goal', :foreign_key => 'parent_id'

    after_create :create_commitment

    attr_accessible :name, :owner_id, :points, :parent_id, :description, :has_deadline, :deadline, :badge, :color

    validates_presence_of :owner_id, :name


    # Before save -> need to make sure name not duplicate in the same scope, including subgoals

    # Permissions
    def self.listable_by?(user)
        # no one can see list of goals
        false
    end

    def creatable_by?(user)
        # anybody can create a goal
        true
    end

    def destroyable_by?(user)
        self.owner_id == user.id
    end

    def updatable_by?(user)
        !user.nil? && !Commitment.find_by_user_id_and_goal_id(user.id, self.id).nil?
    end

    def viewable_by?(user)
        !user.nil? && !Commitment.find_by_user_id_and_goal_id(user.id, self.id).nil?
    end

    def owned_by?(user)
        user = self.owner_id
    end


    private

    def create_commitment
        # relationship automatically added
        current_user = self.owner
        auto_add = self.parent_id > 0 ? 0 : current_user.auto_add
        current_user.commit_to_goal(self, auto_add)
    end



end
