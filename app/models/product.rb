class Product < ApplicationRecord
  belongs_to :category
  has_many :product_properties
  has_many :characteristics, through: :product_properties
  has_many :prices, as: :priceable
  has_many :pictures, as: :imageable
  has_and_belongs_to_many :authors
  has_many :stocks
end
