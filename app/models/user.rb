class User < ActiveRecord::Base
    
    has_many :commitments
    has_many :goals, :through => :commitments, :uniq => true,
             :select => 'goals.*, commitments.completed_at as completed_at,
                        commitments.completed as completed,
                        commitments.is_current as is_current'

    # has_many    :current_goals,
    #             :through => :commitments,
    #             :class_name => 'Goal',
    #             :source => :goal,
    #             :conditions => {'commitments.completed = ?', true}


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


    private
    
    def create_remember_token
        self.remember_token = SecureRandom.urlsafe_base64
    end

end
