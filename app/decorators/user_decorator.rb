class UserDecorator < Draper::Decorator
  delegate_all

  def full_name
    return '' unless object.addresses.present?
    object.addresses.first.first_name + ' ' + object.addresses.first.last_name
  end
end
