class OrdersController < ApplicationController
  helper OrdersHelper

  before_action :coupon_add, only: [:update_cart]
  before_action :authenticate_user!, only: [:index, :show]

  def index
    @all_sort_params = OrdersHelper::SORTING
    @params = sort_params
    @orders = SorteredOrders.new(current_user.orders, params)
    @order_item = current_order.order_items.new
  end

  def show
    @order = Order.find_by_id(params[:id]).decorate
    present FullOrderPresenter.new(object: @order)
  end

  private

#     def order_items_params
#       params.permit(:order_items => [:quantity])
#     end

    def sort_params
      params.permit(:sort)
    end
end
