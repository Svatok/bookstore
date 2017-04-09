class FullOrderPresenter < Rectify::Presenter
  attribute :object

  def address(address_type)
    object.addresses.address_with_type(address_type).decorate
  end

  def shipping
    object.deliveries.first
  end

  def payment
    object.payments.first.decorate
  end

  def order_items
    object.order_items.only_products.decorate
  end
end
