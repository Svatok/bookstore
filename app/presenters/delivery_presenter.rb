class DeliveryPresenter < Rectify::Presenter
  attribute :object

  def available_shippings
    Product.shippings.decorate
  end
  
  def current_order_shipping
    object.shippings.present? ? object.shippings.first : object.order_items.new
  end 
end
