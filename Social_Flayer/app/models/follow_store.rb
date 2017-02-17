class FollowStore < ApplicationRecord
  belongs_to :user
  belongs_to :store
  validates_uniqueness_of :store_id, :scope => :user_id
  validates :user_id , presence: true
  validates :store_id , presence: true
end
