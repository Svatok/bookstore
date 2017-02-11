class Price < ApplicationRecord
  belongs_to :priceable, polymorphic: true
end
