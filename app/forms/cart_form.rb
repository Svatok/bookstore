class CartForm < Rectify::Form
  attribute :code, String
  attribute :order_items

  def order_items_attributes=(attributes)
    @order_items ||= []
    attributes.each do |i, order_items_params|
      @order_items.push(OrderItem.new(order_items_params))
    end
  end

end
