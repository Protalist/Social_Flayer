class Store < ApplicationRecord
  belongs_to :owner, class_name: 'User'

  has_many :products, dependent: :destroy
  has_many :works, dependent: :destroy
  has_many :admin, :through => :works, :source => 'User'
  has_many :comments
  has_many :follow_stores
  has_many :followers, :through => :follow_stores, :source => 'user'

  acts_as_votable

  validates_uniqueness_of :name, :scope => :owner_id
  validates :name , presence: true
  validates :location , presence: true
  
  def self.search(params)
    stores=Store.joins(:products).distinct
    if params
      if  (params[:type] != nil && params[:type] != "")
        stores=stores.where("type_p LIKE ?", "%#{params[:type]}%")
      end
      if(params[:name] != nil && params[:name] != "")
        stores=stores.where(["stores.name LIKE ?","%#{params[:name]}%"])
      end
    end
    return stores
  end

end
