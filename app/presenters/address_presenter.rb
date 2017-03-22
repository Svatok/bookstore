class AddressPresenter < Rectify::Presenter
  attribute :objects

  def address_form(address_type)
    return objects[address_type.to_sym] if objects.is_a?(Hash)
    UserAddressForm.from_model(objects.find_by(address_type: address_type))
  end
end
