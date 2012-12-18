class User < ActiveRecord::Base
    has_many :goals
    has_many :events
    has_many :months
    attr_accessible :email, :name, :uid, :token, :remember_token

    before_save :create_remember_token

    def self.create_with_omniauth(auth)
        create! do |user|
            user.uid = auth["uid"]
            user.token = auth["credentials"]["token"]
            user.name = auth["info"]["name"]
            user.email = auth["info"]["email"]
        end 
    end

    private
    
    def create_remember_token
        self.remember_token = SecureRandom.urlsafe_base64
    end

end
