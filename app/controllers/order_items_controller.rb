class OrderItemsController < ApplicationController
  before_action :all_quantity_in_cart, only: [:create]
  before_action :coupon_add, only: [:create]

  def create
    @order = current_order
    @order_item = @order.order_items.find_or_initialize_by(product_id: params[:order_item][:product_id])
    @order_item.attributes = order_item_params
    if @order_item.save
      @order.save
      session[:order_id] = @order.id
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, notice: "Product has been added!") }
        format.js { render head :ok }
        end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, notice: "Product has not been added :(") }
        format.js { render head :internal_server_error  }
      end
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

    def coupon_add
      coupon = Product.coupons.find_by(title: params[:coupon][:code])
      params[:order_item] = {}
      params[:order_item][:quantity] = '1'
      return unless coupon.present?
      previous_coupon_delete
      params[:order_item][:product_id] = coupon.id
    end

    def previous_coupon_delete
      coupon = current_order.order_items.select{ |order_item| order_item.product.product_type == 'coupon' }
      return unless coupon.present?
      coupon_item = current_order.order_items.find(coupon.first.id)
      coupon_item.destroy
    end

    def order_item_params
      params.require(:order_item).permit(:quantity, :product_id)
    end

end
