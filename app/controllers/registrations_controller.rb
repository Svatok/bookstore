class RegistrationsController < Devise::RegistrationsController
  include Rectify::ControllerHelpers
  before_action :prepare_address, only: [:edit, :update]

  def update
    super do
      return update_address if params['address_forms'].present?
    end
  end

  def finish_signup
    return @show_errors = true unless request.patch? && params[:user]
    @user = User.find(params[:id])
    return flash[:error] = 'Email not updated.' unless @user.update_attributes(email: params[:user][:email])
    @user.skip_reconfirmation!
    bypass_sign_in resource, scope: resource_name
    flash[:success] = 'Your profile was successfully updated.'
    redirect_to root_path
  end

  protected

  def update_resource(resource, params)
    return super unless update_without_password?
    resource.update_attributes(params)
  end

  def update_without_password?
    return true unless params[:user].present?
    params[:user][:password].blank? && params[:user][:password_confirmation].blank?
  end

  def prepare_address
    @countries = Country.all
    present AddressPresenter.new(object: @user)
  end

  def update_address
    SetAddress.call({ object: current_user, params: params }) do
      on(:ok) do
        flash[:success] = 'Address has been updated.'
        redirect_to edit_user_registration_path
      end
      on(:invalid) { |object_with_errors| expose(object: object_with_errors) and return render :edit }
    end
  end
end
