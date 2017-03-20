class AddressesController < ApplicationController

  def create
    form_with_errors = false
    addresses_params['address_forms'].each do |address_type, address_params|
      address_form = instance_variable_set("@#{address_type}_address_form", UserAddressForm.from_params(address_params))
      next unless params[address_type] == 'true'
      if address_form.valid?
        @address = current_user.addresses.find_by(id: address_params['id'])
        @address = current_user.addresses.new unless @address.present?
        @address.attributes = address_form.attributes.except('id')
        @address.save
      else
        form_with_errors = true
      end
    end
    return render :template => 'devise/registrations/edit',
                      :locals => {
                        :resource => current_user,
                        :resource_name => 'user' } if form_with_errors
    flash[:success] = "Address has been updated."
    redirect_to edit_user_registration_path
  end

  # def update
  #   adress_create_or_update(params)
  # end

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

    def addresses_params
      params.permit(address_forms: [billing: [ :id, :address_type, :first_name,
                                              :last_name, :address, :city, :zip,
                                              :country_id, :phone],
                                    shipping: [:id, :address_type, :first_name,
                                                :last_name, :address, :city, :zip,
                                                :country_id, :phone]
                                    ]
                      )
    end

end
