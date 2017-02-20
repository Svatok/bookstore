class Price < ApplicationRecord
  belongs_to :priceable, polymorphic: true
  scope :actual, -> { where("prices.date_start <= '#{Date.today.to_s}'").order(date_start: :desc).limit(1) }

end
