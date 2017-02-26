class Address < ApplicationRecord
  belongs_to :user
  belongs_to :country
  scope :billing, -> { where("address_type = 'billing'").limit(1) }


end
