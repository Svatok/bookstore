class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :product_present
  validate :order_present
  before_save :finalize, :set_inactive_for_coupon
  before_destroy :set_active_for_coupon
  scope :only_products, -> { joins(:product).merge(Product.main) }
  scope :only_shippings, -> { joins(:product).merge(Product.shippings) }
  scope :only_coupons, -> { joins(:product).merge(Product.coupons) }

  def unit_price
    product.prices.actual.first.value
  end

   def total_price
     unit_price * quantity
   end

 private
   def product_present
     if product.nil?
       errors.add(:product, "is not valid or is not active.")
     end
   end

   def order_present
     if order.nil?
       errors.add(:order, "is not a valid order.")
     end
   end

   def finalize
     self[:unit_price] = unit_price
   end

   def set_inactive_for_coupon
     self.product.update_attributes(status: 'inactive') if self.product.product_type == 'coupon'
   end

   def set_active_for_coupon
     self.product.update_attributes(status: 'active') if self.product.product_type == 'coupon'
   end

  end
