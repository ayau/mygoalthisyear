class Month < ActiveRecord::Base
    belongs_to :user
    has_many :goalsinmonths
    has_many :goals, :through => :goalsinmonths, :uniq => true

    attr_accessible :user_id

    validates :user_id, presence: true

end
