class Store < ApplicationRecord
  belongs_to :owner, class_name: 'User'

  has_many :products, dependent: :destroy
  acts_as_votable
  validates_uniqueness_of :name, :scope => :owner_id

  validates :name , presence: true
  validates :location , presence: true
end
