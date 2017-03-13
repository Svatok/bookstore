class RegistrationsController < Devise::RegistrationsController

  def edit
    @countries = Country.all
    billing_address = @user.addresses.billing
    @billing_address_form = billing_address.present? ? UserAddressForm.from_model(billing_address.first) : UserAddressForm.new
    shipping_address = @user.addresses.shipping
    @shipping_address_form = shipping_address.present? ? UserAddressForm.from_model(shipping_address.first) : UserAddressForm.new
    super
  end

  def update
    @countries = Country.all
    billing_address = @user.addresses.billing
    @billing_address_form = billing_address.present? ? UserAddressForm.from_model(billing_address.first) : UserAddressForm.new
    shipping_address = @user.addresses.shipping
    @shipping_address_form = shipping_address.present? ? UserAddressForm.from_model(shipping_address.first) : UserAddressForm.new
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)
    resource_updated = if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      @user.update_attributes(account_update_params)
    else
      update_resource(resource, account_update_params)
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
  end

  def finish_signup
    if request.patch? && params[:user]
      @user = User.find(params[:id])
      if @user.update_attributes(email: params[:user][:email])
        @user.skip_reconfirmation!
        bypass_sign_in resource, scope: resource_name
        flash[:success] = 'Your profile was successfully updated.'
        redirect_to root_path
      else
        @show_errors = true
      end
    end
  end

end
