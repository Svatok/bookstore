class Stock < ApplicationRecord
  belongs_to :product
  scope :actual, -> { where("date_start <= '#{Date.today.to_s}'").order(date_start: :desc).limit(1) }
end
