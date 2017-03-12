class CheckoutsController < ApplicationController
  before_action :authenticate_user!
  before_action :initialize_order, :edit_order_data, only: :show
  before_filter :ensure_signup_complete, only: [:show, :update]


  def show
    @partial = @order.state
    return redirect_to root_path unless lookup_context.exists?(@partial, ["checkouts"], true)
    send(@order.state + '_show')
  end

  def update
    @form_with_errors = false
    @order = current_order.decorate
    @partial = @order.state
    send(@order.state + '_update')
    return render :show if @form_with_errors
    @order.send(next_state + '_step')
    @order.save
    redirect_to checkouts_path
  end

  def address_show
    billing_address = @order.addresses.billing.present? ? @order.addresses.billing : current_user.addresses.billing
    @billing_address_form = billing_address.present? ? UserAddressForm.from_model(billing_address.first) : UserAddressForm.new
    shipping_address = @order.addresses.shipping.present? ? @order.addresses.shipping : current_user.addresses.shipping
    @shipping_address_form = shipping_address.present? ? UserAddressForm.from_model(shipping_address.first) : UserAddressForm.new
  end

  def address_update
    addresses_params['address_forms'].each do |address_type, address_params|
      address_form = instance_variable_set("@#{address_type}_address_form", UserAddressForm.from_params(address_params))
      if params['use_billing'] == 'on' && address_type == 'shipping'
        address_form = @billing_address_form
        address_form.address_type = address_type
      end
      if address_form.valid?
        @address = @order.addresses.find_by(id: address_params['id'])
        @address = @order.addresses.new unless @address.present?
        @address.attributes = address_form.attributes.except('id')
        @address.save
      else
        @form_with_errors = true
      end
    end
  end

  def delivery_show
    @shippings = Product.shippings.decorate
    shipping = @order.order_items.only_shippings
    @current_shipping = shipping.present? ? shipping.first : @order.order_items.new

    # @current_shipping = @order.order_items.only_shippings.first
    # @current_shipping = @order.order_items.new unless @current_shipping.present?
  end

  def delivery_update
    @shippings = Product.shippings.decorate
    shipping = @order.order_items.only_shippings
    @current_shipping = shipping.present? ? shipping.first : @order.order_items.new
    # @current_shipping = @order.order_items.only_shippings.first
    # @current_shipping = @order.order_items.new unless @current_shipping.present?
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

  def initialize_order
    @order = current_order.decorate
    return if !@order.cart? || @order.total_price <= 0
    @order[:user_id] = current_user.id
    @order.address_step
    @order.save
  end

  def edit_order_data
    @order_states = @order.aasm.states.map(&:name)
    @order.send(params['edit'] + '_step') if params['edit'].present? && @order_states.include?(params['edit'].to_sym)
    @order.save
  end

  def next_state
    return @order.prev_state if @order.prev_state == 'confirm' && @order.state != 'complete'
    return 'complete' if @order.confirm?
    @order.aasm.states(permitted: true).map(&:name).first.to_s
  end

  private

  def addresses_params
    params.permit(address_forms: [billing: [ :id, :address_type, :first_name,
                                            :last_name, :address, :city, :zip,
                                            :country_id, :phone],
                                  shipping: [:id, :address_type, :first_name,
                                              :last_name, :address, :city, :zip,
                                              :country_id, :phone]
                                  ]
                    )
  end

  def payment_params
    params.permit(payment: [:card_number, :name_on_card, :mm_yy, :cvv])
  end


end
