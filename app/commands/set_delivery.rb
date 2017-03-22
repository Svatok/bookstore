class SetDelivery < Rectify::Command
  def initialize(options)
    @params = options[:params]
    @object = options[:object]
    @order_shippings = {}
  end
  
  def call
    order_shipping = current_order_shipping || @object.order_items.new(quantity: 1)
    return order_shipping.product = selected_shipping and broadcast(:ok) if selected_shipping.present?
    order_shipping.errors.add(:product_id, "Choose delivery!")
    @order_shippings[order_shipping.id.to_sym] = order_shipping
    broadcast(:invalid, @order_shippings)
  end

  private

  def current_order_shipping
    order_shippings = @object.shippings
    order_shippings.first if order_shippings.present?
  end
  
  def selected_shipping
    Product.shippings.find(@params['shippings_' + @params['form_visible']]['product'])
  end
end
