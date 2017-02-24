class Product < ApplicationRecord
  belongs_to :store

  mount_uploader :image, ImageUploader
  validates_uniqueness_of :name, :scope => :store_id
  validates :duration_h, presence:  true, :numericality => {:only_integer => true}
  validates :price, presence: true, :numericality => true
  validates :name, presence: true
  validates :type_p, presence: true
  validate :number_products

  has_many :follow_product, dependent: :destroy
  has_many :followers, :through => :follow_product, :source => 'user'



  def time_offer
   time=(self.duration_h*3600)-(Time.now.to_i-self.created_at.to_i)
   if time<0
     'expired'
   else
     case time
       when 0 then 'just now'
       when 1 then 'a second '
       when 2..59 then time.to_s+' seconds'
       when 60..119 then 'a minute' #120 = 2 minutes
       when 120..3540 then (time/60).to_i.to_s+' minutes'
       when 3541..7100 then 'an hour ' # 3600 = 1 hour
       when 7101..82800 then ((time+99)/3600).to_i.to_s+' hours'
       when 82801..172000 then 'a day' # 86400 = 1 day
       when 172001..518400 then ((time+800)/(60*60*24)).to_i.to_s+' days'
       when 518400..1036800 then 'a week'
       else ((time+180000)/(60*60*24*7)).to_i.to_s+' weeks '
     end
   end
 end

  private

  def number_products
  errors.add(:too_much, " products") if self.store.products.count > 5
  end



end
