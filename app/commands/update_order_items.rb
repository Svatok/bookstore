class UpdateOrderItems < Rectify::Command
  def initialize(options)
    @order = options[:object]
    @params = options[:params]
    @coupon_msg = {}
  end

  def call
    coupon_add if @params[:coupon].present? && @params[:coupon][:code] != ''
    return if @params[:coupon_only].present? || cart_empty?
    result = @params['delete'].present? ? delete_order_items : change_order_items
    return broadcast(:invalid) unless result
    session[:order_id] = @order.id unless session_present?
    broadcast(:ok, @coupon_msg)
  end

  private

  def cart_empty?
    !@params[:order_item].present? && !@params[:order_items].present? && !@params['delete'].present?
  end

  def delete_order_items
    order_item = @order.order_items.find_by(product_id: @params['product'])
    return unless order_item.present?
    order_item.destroy
  end

  def change_order_items
    set_order_items
    @order_items.each do |product_id, order_item_params|
      order_item = @order.order_items.find_or_initialize_by(product_id: product_id)
      return false unless order_item.update_attributes(quantity: order_item_params[:quantity])
    end
  end

  def set_order_items
    @order_items = {}
    return @order_items = @params[:order_items] if @params[:order_items].present?
    @params[:order_item][:quantity] = all_quantity_in_cart(@params[:order_item][:product_id]).to_s
    @order_items[@params[:order_item][:product_id]] = @params[:order_item]
  end

  def all_quantity_in_cart(product_id)
    quantity_in_cart = in_cart?(product_id) ? @order.order_items.find_by(product_id: product_id).quantity : 0
    @params[:order_item][:quantity].to_i + quantity_in_cart
  end

  def in_cart?(product_id)
    @order.order_items.find_by(product_id: product_id).present?
  end

  def coupon_add
    coupon = Product.coupons.find_by(title: @params[:coupon][:code], status: 'active')
    return @coupon_msg[:error] = 'Coupon is not valid or not active!' unless coupon.present?
    previous_coupon_delete
    @order.order_items.create(product_id: coupon.id, quantity: 1)
  end

  def previous_coupon_delete
    coupon = @order.order_items.only_coupons
    return unless coupon.present?
    @order.order_items.find(coupon.first.id).destroy
  end

  def session_present?
    session[:order_id] == @order.id
  end
end
