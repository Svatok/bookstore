class DeliveryPresenter < Rectify::Presenter
  attribute :object
  attribute :new_order_shipping, OrderItem, :default => current_order.order_items.new

  def available_shippings
    Product.shippings.decorate
  end
  
  def current_order_shipping
    object || new_order_shipping
  end
  
end
