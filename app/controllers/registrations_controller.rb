class RegistrationsController < Devise::RegistrationsController

  def edit
    billing_address = @user.addresses.billing
    @billing_address_form = UserAddressForm.new
    @countries = Country.all
#    @billing_address_form = billing_address.present? ? AddressForm.from_model(billing_address) : AddressForm.new
    super
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      resource_updated = @user.update_attributes(account_update_params)
    else
      resource_updated = update_resource(resource, account_update_params)
    end
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      bypass_sign_in resource, scope: resource_name
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
    @billing_address_form = AddressForm.from_params(params)

    if @billing_address_form.valid?
      Address.create!(@billing_address_form.attributes)
    else
      render :edit
    end
  end
end
