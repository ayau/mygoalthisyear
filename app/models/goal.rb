class Goal < ActiveRecord::Base
    belongs_to :user
    has_many :events, :dependent => :destroy
    has_many :goalsinmonths
    has_many :months, :through => :goalsinmonths, :uniq => true
    has_ancestry

    attr_accessible :completed, :name, :user_id, :completed_at, :points, :parent_id, :description, :has_deadline, :deadline

    validates_presence_of :user_id, :name
end
