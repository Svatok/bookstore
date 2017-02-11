class Characteristic < ApplicationRecord
  has_many :product_properties
  has_many :products, through: :product_properties
end
