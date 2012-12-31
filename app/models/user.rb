class User < ActiveRecord::Base

    # has_restful_permissions
    
    has_many :commitments

    has_many :goals, :through => :commitments, :uniq => true,
             :conditions => {:parent_id => 0},
             :select => 'goals.*, commitments.completed_at as completed_at,
                        commitments.completed as completed,
                        commitments.is_current as is_current'

    has_many :subgoals, :through => :commitments, :uniq => true, :source => :goal,
             :conditions => 'goals.parent_id > 0',
             :select => 'goals.*, commitments.completed_at as completed_at,
                        commitments.completed as completed,
                        commitments.is_current as is_current'

    has_many :events

    attr_accessible :email, :name, :uid, :token, :remember_token, :auto_add

    before_save :create_remember_token

    def self.create_with_omniauth(auth)
        create! do |user|
            user.uid = auth["uid"]
            user.token = auth["credentials"]["token"]
            user.name = auth["info"]["name"]
            user.email = auth["info"]["email"]
        end 
    end

    def commit_to_goal (goal, auto_add)

        self.commitments.create(:goal_id => goal.id, :is_current => auto_add)

        # if goal && !self.goals.include?(goal)
        #     self.goals << goal
        # end

        # Adding descendants to month
        # for d in goal.descendants
        #     unless self.goals.include?(d)
        #         self.goals << d
        #     end
        # end
        
    end


    # Permissions
    def self.listable_by?(user)
        # no one can see list of users
        false
    end

    def creatable_by?(user)
        # anybody can create an account
        true
    end

    def destroyable_by?(user)
        # no deleting of users at this point
        false
    end

    def updatable_by?(user)
        user == self
    end

    def viewable_by?(user)
        user == self
    end

    def owned_by?(user)
        user == self
    end


    private
    
    def create_remember_token
        self.remember_token = SecureRandom.urlsafe_base64
    end

end
