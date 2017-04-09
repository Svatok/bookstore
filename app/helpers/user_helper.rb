module UserHelper

  def full_name(user)
    user.present? ? UserDecorator.new(user).full_name : ''
  end
end
