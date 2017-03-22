class AddressPresenter < Rectify::Presenter
  attribute :objects
  attribute :new_address, UserAddressForm, :default => UserAddressForm.new

  def address_form(address_type)
    forms_has_errors? ? form_with_errors(address_type) : form_without_errors(address_type) 
  end
  
  private
  
  def form_with_errors(address_type)
    objects[address_type.to_sym]
  end
  
  def forms_has_errors?
    objects.is_a?(Hash)
  end

  def form_without_errors(address_type)
    address = objects.find_by(address_type: address_type) || current_user.addresses.find_by(address_type: address_type)
    address.present? ? UserAddressForm.from_model(address) : new_address
  end
  
end
