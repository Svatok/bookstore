class OrderMailer < ApplicationMailer

  default from: 'bookstore@example.com'

  def order_complete(order, user)
    @order = order.decorate
    @order_items = @order.order_items.only_products.decorate
    @user = user
    mail(to: @user.email, subject: 'Order ' + @order.order_number + ' created!')
  end
end
