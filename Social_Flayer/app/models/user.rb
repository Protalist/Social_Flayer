class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  attr_readonly :admin
  validates :name , presence: true
  validates :surname , presence: true
  validates :username , presence: true, uniqueness: true



  acts_as_voter

  mount_uploader :image, ImageUploader
  has_many :stores, :through => :owner, source: :store
  has_many :store, foreign_key: :owner_id, class_name: "Store", dependent: :destroy

  has_many :works, dependent: :destroy
  has_many :workstores, :through => :works, :source => 'store'
  has_many :comments, dependent: :destroy

  has_many :follow_stores,dependent: :destroy
  has_many :followed_store, :through => :follow_stores, :source => 'Store'

  has_many :followers, :through => :follower, :source => :follower
  has_many :follower, foreign_key: :follower_id, class_name: "FollowerUser", dependent: :destroy

  has_many :followeds, :through => :followed, :source => :followed
  has_many :followed, foreign_key: :followed_id, class_name: "FollowerUser", dependent: :destroy

  has_many :follow_product, dependent: :destroy
  has_many :followed_product, :through => :follow_product, :source => 'Product'

  has_many :reporters, :through => :reporter, :source => :reporter
  has_many :reporter, foreign_key: :reporter_id, class_name: "Report", dependent: :destroy

  has_many :reporteds, :through => :reported, :source => :reported
  has_many :reported, foreign_key: :reported_id, class_name: "Report", dependent: :destroy

  def self.from_omniauth(auth, f)
    item=auth.extra.raw_info.name.split
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        f[:notice]="questa è la tua password per modificare il tuo account: "+"'"+user.password+"' "+"questo messaggio non verrà più mostrato quindi bisogna salvarsi questa password"
        user.name=item[0]
        user.surname=item[1]
        #user.remote_image_url = auth.info.image
        user.username=auth.info.email+"/"+item[0]+"/"+item[1]
    end
  end

  private

end
