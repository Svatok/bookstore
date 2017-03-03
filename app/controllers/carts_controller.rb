class CartsController < ApplicationController
  before_action :coupon_add, only: [:update]


  def show
    @order = current_order.decorate
    @coupon = CouponForm.new
    @order_items = current_order.order_items.only_products.decorate
  end

  def update
    params[:order_items] = [] if params[:coupon_only].present?
    @order = current_order
    params[:order_items].each do |order_item_id, order_item_params|
      @order_item = @order.order_items.find(order_item_id)
      next unless @order_item.present?
      @order_item.update_attributes(quantity: order_item_params[:quantity])
      @order.save
    end
    redirect_back(fallback_location: root_path)
  end

  private

    def coupon_add
      code = params[:coupon][:code]
      return unless code.present?
      coupon = Product.coupons.find_by(title: code)
      return unless coupon.present?
      previous_coupon_delete
      current_order.order_items.create(product_id: coupon.id, quantity: 1)
    end

    def previous_coupon_delete
      coupon = current_order.order_items.select{ |order_item| order_item.product.product_type == 'coupon' }
      return unless coupon.present?
      coupon_item = current_order.order_items.find(coupon.first.id)
      coupon_item.destroy
    end

    def order_items_params
      params.permit(:order_items => [:quantity])
    end

end
