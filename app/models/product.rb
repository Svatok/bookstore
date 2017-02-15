class Product < ApplicationRecord
  belongs_to :category
  has_many :characteristics
  has_many :properties, through: :characteristics
  has_many :prices, as: :priceable
  has_many :pictures, as: :imageable
  has_and_belongs_to_many :authors
  has_many :stocks
  scope :in_stock1, -> { eager_load(:stocks).merge(Stock.actual).where('stocks.value > 0') }
  scope :in_stock, -> { eager_load(:stocks).where("(SELECT stocks.value FROM stocks
    WHERE (stocks.date_start <= '#{Date.today.to_s}') AND stocks.product_id = products.id
    ORDER BY stocks.date_start DESC LIMIT 1) > 0") }
  scope :lattest_products, -> (products_count) { order(created_at: :desc).limit(products_count) }
  scope :best_sellers, -> (products_count) { limit(products_count) }
end
