class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :categories
  before_filter :ensure_signup_complete, only: [:new, :create, :update, :destroy]
  helper_method :current_order

  def authenticate_active_admin_user!
   authenticate_user!
   unless current_user.role?(:admin)
    flash[:alert] = 'You are not authorized to access this resource!'
    redirect_to root_path
   end
  end

  def current_order
    if !session[:order_id].nil?
      Order.find(session[:order_id])
    else
      Order.new
    end
  end

  def ensure_signup_complete
    return if action_name == 'finish_signup'
    if current_user && !current_user.email_verified?
      redirect_to finish_signup_path(current_user)
    end
  end

  private
    def categories
      @categories = Category.all.order(default_sort: :desc)
    end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password, :password_confirmation, :current_password) }
  end

end
