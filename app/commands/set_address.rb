class SetAddress < Rectify::Command
  def initialize(options)
    @params = options[:params]
    @object = options[:object]
    set_address_forms
  end

  def create
    addresses_params['address_forms'].each do |address_type, address_params|
      address_form = instance_variable_set("@#{address_type}_address_form", UserAddressForm.from_params(address_params))
      next unless params[address_type] == 'true'
      if address_form.valid?
        @address = current_user.addresses.find_by(id: address_params['id'])
        @address = current_user.addresses.new unless @address.present?
        @address.attributes = address_form.attributes.except('id')
        @address.save
      else
        form_with_errors = true
      end
    end
    return render :template => 'devise/registrations/edit',
                      :locals => {
                        :resource => current_user,
                        :resource_name => 'user' } if form_with_errors
    flash[:success] = "Address has been updated."
    redirect_to edit_user_registration_path
  end
  
  def call
    @address_forms.each do |address_type, address_form|
      next unless @params[address_type] == 'true'
      return broadcast(:invalid, @address_forms) unless address_form.valid?
      set_address
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

  def set_address
    @address = @object.addresses.find_or_initialize_by(address_type: address_type)
    @address.update_attributes(address_form.attributes)
  end

  def permit_params(params)
    params.permit(
      :address_type, :first_name, :last_name, :address, :city, :zip,
      :country_id, :phone
    )
  end
end
