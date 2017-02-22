class Product < ApplicationRecord
  belongs_to :category
  has_many :characteristics
  has_many :properties, through: :characteristics
  has_many :prices, as: :priceable
  has_many :pictures, as: :imageable
  has_and_belongs_to_many :authors
  has_many :stocks
  scope :in_stock, ->{ joins( "INNER JOIN (SELECT a.* FROM stocks as a
                                WHERE EXISTS (SELECT 1 FROM stocks as b
                                                WHERE a.product_id = b.product_id
                                                  AND b.date_start <= '#{Date.today}'
                                                HAVING MAX(b.date_start) = a.date_start)
                                      AND a.value > 0
                              ) as s
                              ON products.id = s.product_id") }
  scope :lattest_products, ->(products_count) { in_stock.order(created_at: :desc).limit(products_count) }
  scope :best_sellers, ->(products_count) { limit(products_count) }
  scope :with_category, ->(category) { in_stock.where(category: category) }
  paginates_per 2
end
