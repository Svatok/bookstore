class CheckoutsController < ApplicationController
  include Rectify::ControllerHelpers

  before_action :authenticate_user!, :prepare_checkout, :ensure_signup_complete

  def show
  end

  def update
    options = { object: current_order, params: params }
    "Set#{@order.state.capitalize}".constantize.call(options) do
      on(:ok) do
        # send(@order.state + '_update!')
        redirect_to checkouts_path
      end
      on(:invalid) { |forms| expose(object: object_with_errors) and render :show }
    end
  end

  def confirm_show
    @billing_address = @order.addresses.billing.first.decorate
    @shipping_address = @order.addresses.shipping.first.decorate
    @shipping = @order.order_items.only_shippings.first
    @payment = @order.payments.first.decorate
    @order_items = @order.order_items.only_products.decorate
  end

  def confirm_update
    @order.order_number = "R%.8d" % @order.id
    @order.placed_date = Date.today
    OrderMailer.order_complete(@order, current_user).deliver
  end

  def complete_show
    @shipping_address = @order.addresses.shipping.first.decorate
    @shipping = @order.order_items.only_shippings.first
    @payment = @order.payments.first.decorate
    @order_items = @order.order_items.only_products.decorate
  end

  def complete_update
    session.delete(:order_id)
  end

  private

  def prepare_checkout
    options = { object: current_order, params: params }
    PrepareCheckout.call(options) do
      on(:ok) do |order, view_partial|
        expose(order: order, view_partial: view_partial)
        present "#{order.state.capitalize}Presenter".constantize.new(object: order)
      end
      on(:invalid) { redirect_to root_path }
    end
  end

  def next_state
    return @order.prev_state if @order.prev_state == 'confirm' && @order.state != 'complete'
    return 'complete' if @order.confirm?
    @order.aasm.states(permitted: true).map(&:name).first.to_s
  end

end
