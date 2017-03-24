class OrderDecorator < Draper::Decorator
  delegate_all

  def discount
    object.coupon_sum * -1
  end

  def subtotal_price
    object.total_price ||= 0
    object.total_price - object.coupon_sum - object.shipping_cost
  end
end
