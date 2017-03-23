class CartController < ApplicationController

  def show
    @order = current_order.decorate
    @coupon = CouponForm.new
    @order_items = current_order.order_items.only_products.decorate
  end

  def update
    UpdateOrderItems.call({ object: current_user, params: params }) do
      on(:ok) {}
      on(:invalid) { |msg| flash[:error] = msg }
    end
    redirect_back(fallback_location: root_path)
  end
end
