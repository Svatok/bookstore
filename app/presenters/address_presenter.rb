class AddressPresenter < Rectify::Presenter
  attribute :object
  attribute :new_address, UserAddressForm, :default => UserAddressForm.new

  def address_form(address_type)
    return form_with_errors(address_type) if forms_has_errors?
    form_without_errors(address_type)
  end
  
  private
  
  def form_with_errors(address_type)
    object[address_type.to_sym]
  end
  
  def forms_has_errors?
    object.is_a?(Hash)
  end

  def form_without_errors(address_type)
    address = @object.find_by(address_type: address_type) || current_user.addresses.find_by(address_type: address_type)
    address.present? ? UserAddressForm.from_model(address) : new_address
  end
  
end
