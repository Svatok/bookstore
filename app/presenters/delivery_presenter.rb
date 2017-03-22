class DeliveryPresenter < Rectify::Presenter
  attribute :objects
  attribute :new_order_shipping, OrderItem, :default => current_order.order_items.new

  def available_shippings
    Product.shippings.decorate
  end
  
  def current_order_shipping
    objects.first || new_order_shipping
  end 
end
