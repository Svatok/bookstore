class Property < ApplicationRecord
  has_many :characteristics
  has_many :products, through: :characteristics
end
