class FollowerUser < ApplicationRecord
    belongs_to :follower, Class: ‘User’
    belongs_to :following, Class: ‘User’
end
