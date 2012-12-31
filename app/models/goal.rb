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

    # has_many :months, :through => :goalsinmonths, :uniq => true

    attr_accessible :name, :owner_id, :points, :parent_id, :description, :has_deadline, :deadline, :badge, :color

    validates_presence_of :owner_id, :name


    # Before save -> need to make sure name not duplicate in the same scope



    private

    def create_commitment
        # relationship automatically added
        current_user = self.owner
        auto_add = self.parent_id > 0 ? 0 : current_user.auto_add
        current_user.commit_to_goal(self, auto_add)
    end



end
