class Notification < ActiveRecord::Base
    belongs_to :goal
    belongs_to :user
    belongs_to :sender, :class_name => 'User', :foreign_key => 'sender_id'

    attr_accessible :message, :read, :created_at, :notification_type

end
