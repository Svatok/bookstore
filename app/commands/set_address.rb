class SetAddress < Rectify::Command
  def initialize(options)
    @params = options[:params]
    @object = options[:object]
    set_address_forms
  end
  
  def call
    @address_forms.each do |address_type, address_form|
      next unless needs_to_be_updated?(address_type)
      return broadcast(:invalid, @address_forms) unless address_form.valid?
      set_address(address_type, address_form)
    end
    broadcast(:ok)
  end

  private

  def set_address_forms
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
  
  def needs_to_be_updated?(address_type)
    !@params['only_address_type'].present? && @params['only_address_type'] == address_type
  end

  def set_address(address_type, address_form)
    @object.addresses.find_or_initialize_by(address_type: address_type).update_attributes(address_form.attributes)
  end

  def permit_params(params)
    params.permit(
      :address_type, :first_name, :last_name, :address, :city, :zip,
      :country_id, :phone
    )
  end
end
