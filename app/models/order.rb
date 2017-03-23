class Order < ApplicationRecord
  include OrderStateMachine

  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :addresses, as: :addressable, dependent: :destroy

  before_save :update_total_price

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
  
  def next_state
    return @order.prev_state if @order.prev_state == 'confirm' && @order.state != 'complete'
    return 'complete' if @order.confirm?
    @order.aasm.states(permitted: true).map(&:name).first.to_s
  end

  private

  def update_total_price
    self[:total_price] = order_items.collect { |order_item| order_item.valid? ? (order_item.quantity * order_item.unit_price) : 0 }.sum
  end
  
  def set_prev_state!
    assign_attributes(prev_state: aasm.from_state)
  end
end
