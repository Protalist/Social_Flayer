class PhotoStore < ApplicationRecord
  belongs_to :store
  mount_uploader :image, ImageUploader
  validates :image, presence: true
end
