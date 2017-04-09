class Characteristic < ApplicationRecord
  belongs_to :product
  belongs_to :property
  scope :dimensions_value, -> { joins(:property).merge(Property.dimensions) }
  scope :property, ->(property) { joins(:property).where("properties.name = '#{property}'") }
end
