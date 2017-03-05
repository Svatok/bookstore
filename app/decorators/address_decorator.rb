class AddressDecorator < Draper::Decorator
  delegate_all

  def address_name
    first_name + ' ' + last_name
  end

  def city_and_zip
    city + ' ' + zip
  end

  def phone_number
    'Phone ' + phone
  end
end
