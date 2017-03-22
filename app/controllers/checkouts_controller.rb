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
      on(:invalid) { |forms| expose(objects: forms) and render :show }
    end
  end

  # def address_show
  #   billing_address = @order.addresses.billing.present? ? @order.addresses.billing : current_user.addresses.billing
  #   @billing_address_form = billing_address.present? ? UserAddressForm.from_model(billing_address.first) : UserAddressForm.new
  #   shipping_address = @order.addresses.shipping.present? ? @order.addresses.shipping : current_user.addresses.shipping
  #   @shipping_address_form = shipping_address.present? ? UserAddressForm.from_model(shipping_address.first) : UserAddressForm.new
  # end

  def delivery_show
    @shippings = Product.shippings.decorate
    shipping = @order.order_items.only_shippings
    @current_shipping = shipping.present? ? shipping.first : @order.order_items.new
  end

  def delivery_update
    @shippings = Product.shippings.decorate
    shipping = @order.order_items.only_shippings
    @current_shipping = shipping.present? ? shipping.first : @order.order_items.new
    shipping = params['shippings_' + params['form_visible']]
    unless shipping.present?
      @current_shipping.errors.add(:product_id, "Choose delivery!")
      return @form_with_errors = true
    end
    @current_shipping.attributes = { product_id: shipping['product'], quantity: 1 }
    @current_shipping.save
  end

  def payment_show
    payment = @order.payments
    @payment_form = payment.present? ? PaymentForm.from_model(payment.first) : PaymentForm.new
  end

  def payment_update
    @payment_form = PaymentForm.from_params(payment_params)
    if @payment_form.valid?
      @payment = @order.payments.present? ? @order.payments.first : @order.payments.new
      @payment.attributes = @payment_form.attributes
      @payment.save
    else
      @form_with_errors = true
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
        present "#{order.state.capitalize}Presenter".constantize.new(objects: order.send(order.state.pluralize))
      end
      on(:invalid) { redirect_to root_path }
    end
  end

  def next_state
    return @order.prev_state if @order.prev_state == 'confirm' && @order.state != 'complete'
    return 'complete' if @order.confirm?
    @order.aasm.states(permitted: true).map(&:name).first.to_s
  end

  def payment_params
    params.permit(payment: [:card_number, :name_on_card, :mm_yy, :cvv])
  end

end
