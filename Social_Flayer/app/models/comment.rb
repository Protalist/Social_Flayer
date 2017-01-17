class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :store
  
  
  #auto join
  belongs_to :primary, :class_name => 'Comment'
  has_many :replys, :class_name => 'Comment'
  
  
  validates :content , presence: true
  
end
