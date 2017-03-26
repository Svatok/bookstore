class CartsController < ApplicationController

  def show
    @order = current_order.decorate
    @coupon = CouponForm.new
    @order_items = current_order.order_items.only_products.decorate
  end

  def update
    UpdateOrderItems.call({ object: current_order, params: params }) do
      on(:ok) do |coupon_msg|
        coupon_msg.present? ? flash[:error] = coupon_msg[:error] : flash[:success] = 'Your cart was updated!'
      end
      on(:invalid) { flash[:error] = 'Your cart not updated!' }
    end
    redirect_back(fallback_location: root_path)
  end
end
