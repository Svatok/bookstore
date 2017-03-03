class Order < ApplicationRecord
  belongs_to :user
  before_save :update_total_price
  has_many :order_items

  def total_price
    order_items.collect { |order_item| order_item.valid? ? (order_item.quantity * order_item.unit_price) : 0 }.sum
  end

  def subtotal_price
    total_price - coupon_sum
  end

  def coupon_sum
    coupon = order_items.select{ |order_item| order_item.product.product_type == 'coupon' }
    coupon.first.unit_price if coupon.present?
  end

  private
    def update_total_price
      self[:total_price] = total_price
    end
end
