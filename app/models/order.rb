class Order < ApplicationRecord
  include OrderStateMachine

  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :addresses, as: :addressable, dependent: :destroy

  scope :not_placed, -> { where("state in ('cart', 'address', 'delivert', 'payment', 'confirm', 'complete')") }
  scope :processing, -> { where("state in ('in_waiting', 'in_progress', 'in_delivery')") }
  scope :delivered, -> { where("state = 'delivered'") }
  scope :canceled, -> { where("state = 'canceled'") }

  def coupon_sum
    coupon = order_items.only_coupons
    return 0 unless coupon.present?
    coupon.first.unit_price
  end

  def shipping_cost
    shipping = order_items.only_shippings
    return 0 unless shipping.present?
    shipping.first.unit_price
  end

  def deliveries
    order_items.only_shippings
  end

  def update_total_price!
    self[:total_price] = order_items.collect { |order_item| order_item.valid? ? order_item.total_price : 0 }.sum
    save
  end

  private

  def set_prev_state!
    assign_attributes(prev_state: aasm.from_state)
  end
end
