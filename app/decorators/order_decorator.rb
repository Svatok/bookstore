class OrderDecorator < Draper::Decorator
  delegate_all

  def discount
    object.coupon_sum * (-1)
  end
end
