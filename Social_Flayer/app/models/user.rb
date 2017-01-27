class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  validates :name , presence: true
  validates :surname , presence: true
  validates :username , presence: true, uniqueness: true
  has_many :followerusers, :source => 'FollowUser'
  has_many :followeduser, :source => 'FollowUser'


  acts_as_voter

  has_many :stores, as: :owner, dependent: :destroy
  has_many :works, dependent: :destroy
  has_many :workstores, :through => :works, :source => 'store'
  has_many :comments

  has_many :follower, :source => 'follower_user', as: :follower
  has_many :followed, :source => 'follower_user', as: :followed

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
        user.username=auth.info.email+"/"+item[0]+"/"+item[1]
    end
  end
end
