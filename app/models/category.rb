class Category < ApplicationRecord
  has_many :products, dependent: :destroy

  validates :name, presence: true

  scope :default_sort, -> { where(default_sort: true) }
end
