class SetAddress < Rectify::Command
  def initialize(options)
    @params = options[:params]
    @object = options[:object]
    @address_forms = {}
  end

  def call
    set_addresses_forms
    @address_forms.each do |address_type, address_form|
      return broadcast(:invalid, @address_forms) unless address_form.valid?
      @address = @object.addresses.find_or_initialize_by(address_type: address_type)
      @address.update_attributes(address_form.attributes)
    end
    broadcast(:ok)
  end

  private

  def set_addresses_forms
    @params['address_forms'].each do |address_type, params|
      @address_forms[address_type.to_sym] = UserAddressForm.from_params(address_params(params))
    end
  end

  def address_params(params)
    return permit_params(params) unless use_billing?
    attributes = @address_forms[:billing].attributes
    attributes[:address_type] = 'shipping'
    permit_params(ActionController::Parameters.new(attributes))
  end

  def use_billing?
    @params['use_billing'] == 'on' && @address_forms[:billing].present?
  end

  def permit_params(params)
    params.permit(
      :address_type, :first_name, :last_name, :address, :city, :zip,
      :country_id, :phone
    )
  end
end
