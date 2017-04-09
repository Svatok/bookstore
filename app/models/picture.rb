class Picture < ApplicationRecord
  mount_uploader :image_path, PictureUploader
  belongs_to :imageable, polymorphic: true
  scope :product_imgs, ->(img_quantity = 15) { order(created_at: :desc).limit(img_quantity) }
  scope :no_image, -> { where(imageable_id: '0') }
  scope :avatar, -> { order(created_at: :desc).limit(1) }
end
