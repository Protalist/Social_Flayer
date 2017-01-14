class Product < ApplicationRecord
  belongs_to :store


  validates_uniqueness_of :name, :scope => :store_id
  validates :duration_h, presence:  true, :numericality => {:only_integer => true}
  validates :price, presence: true, :numericality => true
  validates :name, presence: true
  validates :tyoe, presence: true
  validate :number_products


  private

  def number_products
  errors.add(:too_much, " products") if self.store.products.count > 5
  end

end
