class Product < ApplicationRecord
  belongs_to :category
  has_many :characteristics
  has_many :properties, through: :characteristics
  has_many :prices, as: :priceable
  has_many :pictures, as: :imageable
  has_and_belongs_to_many :authors
  has_many :stocks
  has_many :reviews
  has_many :order_items
  has_many :orders, through: :order_items
  scope :main, -> { where(product_type: 'product') }
  scope :coupons, -> { where(product_type: 'coupon') }
  scope :shippings, -> { where(product_type: 'shipping', status: 'active') }
  scope :in_stock, ->{ main.joins( "INNER JOIN (SELECT a.* FROM stocks as a
                                WHERE EXISTS (SELECT 1 FROM stocks as b
                                                WHERE a.product_id = b.product_id
                                                  AND b.date_start <= '#{Date.today}'
                                                HAVING MAX(b.date_start) = a.date_start)
                                      AND a.value > 0
                              ) as s
                              ON products.id = s.product_id") }
  scope :lattest_products, ->(products_count) { order(created_at: :desc).limit(products_count) }
  scope :best_sellers, -> { joins(:orders).group('order_items.product_id', 'products.id')
                                            .order('SUM(order_items.quantity) desc') }
  scope :with_category, ->(category) { in_stock.where(category: category) }

  def self.ransackable_scopes(auth_object = nil)
    [:select_product_type, :main, :coupons, :shippings, :with_category]
  end

  scope :select_product_type, ->status {
    where status: status
  }

  # ransacker :status,
  #         :formatter => ->(v) {
  #           binding.pry
  #              where("products.status = '#{v}'").map(&:id)
  #             } do |parent|
  #     parent.table[:id]
  # end



end
