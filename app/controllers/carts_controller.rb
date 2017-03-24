class CartsController < ApplicationController

  def show
    @order = current_order.decorate
    @coupon = CouponForm.new
    @order_items = current_order.order_items.only_products.decorate
  end

  def update
    UpdateOrderItems.call({ object: current_order, params: params }) do
      on(:ok) { flash[:success] = 'Your cart has been updated!' }
      on(:invalid) { flash[:error] = 'Your cart not updated!' }
    end
    redirect_back(fallback_location: root_path)
  end
end
