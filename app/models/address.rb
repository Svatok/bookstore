class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true
  belongs_to :country
  scope :address_with_type, ->(address_type) { find_by(address_type: address_type) }
end
