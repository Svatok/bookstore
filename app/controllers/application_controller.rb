class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :categories

  def authenticate_active_admin_user!
   authenticate_user!
   unless current_user.role?(:admin)
    flash[:alert] = 'You are not authorized to access this resource!'
    redirect_to root_path
   end
  end

  private
    def categories
      @categories = Category.all
    end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password, :password_confirmation, :current_password) }
  end

end
