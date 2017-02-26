class AddressesController < ApplicationController

  def create
    @billing_address_form = UserAddressForm.from_params(params)
    if @billing_address_form.valid?
      Address.create!(@billing_address_form.attributes)
      redirect_to root_url, notice: "Address ID has been created"
    else
      render :template => 'devise/registrations/edit',
                        :locals => {
                          :resource => current_user,
                          :resource_name => 'user' }
    end
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
  helper_method :resource, :resource_name, :devise_mapping

  private

 # Using strong parameters
 def user_address_form_params
   params.require(:billing_address_form).permit(:first_name, :last_name)
 end

end
