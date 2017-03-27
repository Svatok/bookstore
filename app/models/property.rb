class Property < ApplicationRecord
  has_many :characteristics
  has_many :products, through: :characteristics
  scope :dimensions, -> { where("properties.name IN ('Height', 'Width', 'Depth')") }
end
