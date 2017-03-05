class CheckoutsController < ApplicationController
  before_action :authenticate_user!
  before_action :initialize_order, :edit_order_data, :only => :show

  def show
    @partial = @order.state
    return redirect_to root_path unless lookup_context.exists?(@partial, ["checkouts"], true)
    send(@order.state + '_show')
  end

  def update
    @order = current_order
    send(@order.state + '_update')
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
    form_with_errors = false
    addresses_params['address_forms'].each do |address_type, address_params|
      address_form = instance_variable_set("@#{address_type}_address_form", UserAddressForm.from_params(address_params))
      if address_form.valid?
        binding.pry
        @address = @order.addresses.find_by(id: address_params['id'])
        @address = @order.addresses.new unless @address.present?
        @address.attributes = address_form.attributes.except('id')
        binding.pry
        @address.save
      else
        form_with_errors = true
      end
    end
    return render checkouts_path if form_with_errors
    redirect_to checkouts_path
  end

  def initialize_order
    @order = current_order.decorate
    return unless @order.cart?
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
    return @order.prev_state if @order.prev_state == 'confirm'
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


end
