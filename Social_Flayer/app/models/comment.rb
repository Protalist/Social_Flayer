class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :store


  #auto join
  belongs_to :primary, :class_name => 'Comment'
  has_many :replys, :class_name => 'Comment', dependent: :destroy

  has_many :responds

  validates :content , presence: true
  
  validates :user_id , presence: true
  validates :store_id , presence: true
  

end
