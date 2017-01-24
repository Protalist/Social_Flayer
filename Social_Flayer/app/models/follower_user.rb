class FollowerUser < ApplicationRecord
    belongs_to :follower, class_name: 'User'
    belongs_to :followed, class_name: 'User'

    validates_uniqueness_of :follower_id, :scope => :followed_id

    validate :differente

    private
    def differente
      follower_id!=followed_id
    end

end
