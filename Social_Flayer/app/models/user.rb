class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  validates :name , presence: true
  validates :surname , presence: true
  validates :username , presence: true, uniqueness: true

def self.from_omniauth(auth)
    item=auth.extra.raw_info.name.split
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
          user.provider = auth.provider
          user.uid = auth.uid
          user.email = auth.info.email
          user.password = Devise.friendly_token[0,20]
          user.name=item[0]
          user.surname=item[1]
          user.username=auth.info.email+"/"+item[0]+"/"+item[1]
      end
    end
end
