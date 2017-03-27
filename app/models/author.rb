class Author < ApplicationRecord
  has_and_belongs_to_many :products

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :description, presence: true

end
