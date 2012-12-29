class Goal < ActiveRecord::Base
    belongs_to :owner, :class_name => 'User', :foreign_key => 'owner_id'
    has_many :events, :dependent => :destroy

    after_create :create_commitment

    # has_many :commitments
    # has_many :months, :through => :goalsinmonths, :uniq => true
    has_ancestry

    attr_accessible :name, :owner_id, :points, :parent_id, :description, :has_deadline, :deadline, :badge, :color

    validates_presence_of :owner_id, :name

    private

    def create_commitment
        # relationship automatically added
        current_user = self.owner
        current_user.commit_to_goal(self, current_user.auto_add)
    end



end
