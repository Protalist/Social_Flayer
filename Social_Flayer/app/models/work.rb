class Work < ApplicationRecord
  belongs_to :user
  belongs_to :store
  
  validates_uniqueness_of :store_id, :scope => :user_id
end
