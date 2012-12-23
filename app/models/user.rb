class User < ActiveRecord::Base
    has_many :goals
    has_many :events
    has_many :months
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

    # Retrieves current month object. Creates one if doesn't exist
    def get_month

        months = self.months.order("created_at desc").limit(1)
        month = months[0]
        if !month || month.created_at.beginning_of_month() < Time.now.utc.beginning_of_month()
            param = {
                'user_id' => current_user.id
            }
            month = Month.new(param)
            month.save    
        end

        month
    end


    private
    
    def create_remember_token
        self.remember_token = SecureRandom.urlsafe_base64
    end

end
