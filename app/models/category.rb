class Category < ApplicationRecord
  has_many :products

  scope :default_sort, -> { where(default_sort: true) }
end
