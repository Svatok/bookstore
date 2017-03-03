class CartsController < ApplicationController
  def show
    @coupon = CouponForm.new
    @order_items = current_order.order_items.only_products.decorate
  end
end
