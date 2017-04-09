class Product < ApplicationRecord
  belongs_to :category
  has_many :characteristics, dependent: :destroy
  has_many :properties, through: :characteristics
  has_many :prices, as: :priceable, dependent: :destroy
  has_many :pictures, as: :imageable, dependent: :destroy
  has_and_belongs_to_many :authors
  has_many :stocks, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items
  scope :main, -> { where(product_type: 'product') }
  scope :coupons, -> { where(product_type: 'coupon') }
  scope :shippings, -> { where(product_type: 'shipping', status: 'active') }
  scope :select_product_type, -> status { where status: status }
  scope :in_stock, -> { main.joins(in_stock_query) }
  scope :lattest_products, ->(products_count) { order(created_at: :desc).limit(products_count) }
  scope :best_sellers, -> { joins(:orders).group('order_items.product_id', 'products.id')
                                            .order('SUM(order_items.quantity) desc') }
  scope :with_category, ->(category) { in_stock.where(category: category) }
  scope :newest, -> { order(created_at: :desc) }
  scope :popular, -> { best_sellers }
  scope :price_asc, -> { joins(sort_price_sql).order('p.value ASC') }
  scope :price_desc, -> { joins(sort_price_sql).order('p.value DESC') }
  scope :title_asc, -> { order(title: :asc) }
  scope :title_desc, -> { order(title: :desc) }

  def self.ransackable_scopes(auth_object = nil)
    [:select_product_type, :main, :coupons, :shippings, :with_category]
  end

  private

  def self.in_stock_query
    "INNER JOIN (SELECT a.* FROM stocks as a
                             WHERE EXISTS (SELECT 1 FROM stocks as b
                                                    WHERE a.product_id = b.product_id
                                                      AND b.date_start <= '#{Date.today}'
                                                      HAVING MAX(b.date_start) = a.date_start
                                          )
                               AND a.value > 0
                  ) as s
      ON products.id = s.product_id"
  end

  def self.sort_price_sql
    "INNER JOIN (SELECT a.* FROM prices as a
                                  WHERE EXISTS (SELECT 1 FROM prices as b
                                                  WHERE a.priceable_id = b.priceable_id
                                                    AND a.priceable_type = b.priceable_type
                                                    AND b.priceable_type = 'Product'
                                                    AND b.date_start <= '#{Date.today}'
                                                  HAVING MAX(b.date_start) = a.date_start)
                                ) as p
                                ON products.id = p.priceable_id"
  end

end
