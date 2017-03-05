class AddressesController < ApplicationController

  def create
    binding.pry
    adress_create_or_update(params)
  end

  def update
    binding.pry
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
# "address_forms"=>{"12"=>{"user_id"=>"3", "address_type"=>"billing",
#                         "first_name"=>"Svatok11112", "last_name"=>"Sidelnikov",
#                         "address"=>"Laboratornaya", "city"=>"Dnepr", "zip"=>"49010",
#                         "country_id"=>"1", "phone"=>"+380684053272"
#                         },
#                 "14"=>{"user_id"=>"3", "address_type"=>"shipping",
#                         "first_name"=>"11111111111S", "last_name"=>"last",
#                         "address"=>"3333333333333", "city"=>"444444444444",
#                         "zip"=>"555555555555", "country_id"=>"1",
#                         "phone"=>"6666666666666"
#                       }
#                   }
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

    def addresses_params
      params.permit(:address_forms => [:user_id, :address_type, :first_name,
                                        :last_name, :address, :city, :zip,
                                        :country_id, :phone])
    end


end
