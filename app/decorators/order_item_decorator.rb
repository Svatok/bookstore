class OrderItemDecorator < Draper::Decorator
  delegate_all
  decorates_association :product

  def subtotal
    object.quantity * object.unit_price
  end

end
