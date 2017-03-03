class OrderItemsController < ApplicationController
  before_action :all_quantity_in_cart, only: [:create]

  def create
    @order = current_order
    @order_item = @order.order_items.find_or_initialize_by(product_id: params[:order_item][:product_id])
    @order_item.attributes = order_item_params
    if @order_item.save
      @order.save
      session[:order_id] = @order.id
      redirect_back(fallback_location: root_path, notice: "Product has been added!")
    else
      redirect_back(fallback_location: root_path, notice: "Product has not been added :(")
    end
  end

  def update
    binding.pry
    @order = current_order
    @order_item = @order.order_items.find(params[:id])
    @order_item.update_attributes(order_item_params)
    @order.save
  end

  def destroy
    @order = current_order
    @order_item = @order.order_items.find(params[:id])
    @order_item.destroy
    @order.save
    redirect_back(fallback_location: root_path)
  end

  private

    def all_quantity_in_cart
      return unless params[:order_item].present?
      quantity_in_cart = 0
      quantity_in_cart = current_order.order_items.find_by_product_id(params[:order_item][:product_id]).quantity if in_cart?
      all_quantity = params[:order_item][:quantity].to_i + quantity_in_cart
      params[:order_item][:quantity] = all_quantity.to_s
    end

    def in_cart?
      current_order.order_items.find_by_product_id(params[:order_item][:product_id]).present?
    end

    def order_item_params
      params.require(:order_item).permit(:quantity, :product_id)
    end

end
