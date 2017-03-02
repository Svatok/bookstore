class AddressesController < ApplicationController

  def create
    adress_create_or_update(params)
  end

  def update
    adress_create_or_update(params)
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

    def adress_create_or_update(params)
      address_form = form_which_update(params[:user_address][:address_type])
      if address_form.valid?
        @address = params[:id].present? ? Address.find(params[:id]) : Address.new
        @address.attributes = address_form.attributes
        @address.save
        redirect_to root_url, notice: "Address ID has been created"
      else
        render :template => 'devise/registrations/edit',
                          :locals => {
                            :resource => current_user,
                            :resource_name => 'user' }
      end
    end

    def form_which_update(address_type)
      if address_type == 'billing'
        @billing_address_form = UserAddressForm.from_params(params)
        @shipping_address_form = UserAddressForm.from_model(current_user.addresses.shipping.first)
      else
        @shipping_address_form = UserAddressForm.from_params(params)
        @billing_address_form = UserAddressForm.from_model(current_user.addresses.billing.first)
      end
      instance_variable_get("@#{address_type}_address_form")
    end

end
