class Order < ApplicationRecord
  include AASM

  belongs_to :user
  has_many :order_items
  has_many :addresses, as: :addressable

  before_save :update_total_price

  aasm column: :state do
    state :cart, :initial => true
    state :address, :delivery, :payment, :confirm, :complete, :in_waiting,
          :in_progress, :in_delivery, :delivered, :canceled

    after_all_transitions :set_prev_state!

    event :address_step do
      transitions from: [:cart, :confirm], to: :address
    end

    event :delivery_step do
      transitions :from => [:address, :confirm], :to => :delivery
    end

    event :payment_step do
      transitions :from => [:delivery, :confirm], :to => :payment
    end

    event :confirm_step do
      transitions :from => [:address, :delivery, :payment], :to => :confirm
    end

    event :complete_step do
      transitions :from => :confirm, :to => :complete
    end

    event :in_waiting_step do
      transitions :from => :complete, :to => :in_waiting
    end

    event :in_progress_step do
      transitions :from => :in_waiting, :to => :in_progress
    end

    event :in_delivery_step do
      transitions :from => :in_progress, :to => :in_delivery
    end

    event :delivered_step do
      transitions :from => :in_delivery, :to => :delivered
    end

    event :canceled_step do
      transitions :from => [:cart, :address, :delivery, :payment, :confirm, :complete,
                            :in_waiting, :in_progress, :in_delivery], :to => :canceled
    end
  end

  def set_prev_state!
    update_attributes!(prev_state: aasm.from_state)
  end

  def total_price
    order_items.collect { |order_item| order_item.valid? ? (order_item.quantity * order_item.unit_price) : 0 }.sum
  end

  def subtotal_price
    total_price - coupon_sum
  end

  def coupon_sum
    coupon = order_items.select{ |order_item| order_item.product.product_type == 'coupon' }
    return 0 unless coupon.present?
    coupon.first.unit_price
  end

  private

    def update_total_price
      self[:total_price] = total_price
    end
end
