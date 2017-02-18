class FollowerUser < ApplicationRecord
    belongs_to :follower, class_name: 'User'
    belongs_to :followed, class_name: 'User'

    validates_uniqueness_of :follower_id, :scope => :followed_id
    validates :follower_id , presence: true
    validates :followed_id , presence: true
    validate :differente

    private
    def differente
      if (follower_id==followed_id)
        errors.add(:different,("non puoi seguire te stesso"))
      end
    end

end
