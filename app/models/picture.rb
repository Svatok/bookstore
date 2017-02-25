class Picture < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  scope :product_imgs, ->(img_quantity = 1) { order(created_at: :desc).limit(img_quantity) }
end
