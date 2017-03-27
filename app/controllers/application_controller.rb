class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale, :categories
  helper_method :current_order

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_url, alert: exception.message
  end
  
  def authenticate_active_admin_user!
    authenticate_user!
    return if current_user.role?(:admin)
    flash[:alert] = 'You are not authorized to access this resource!'
    redirect_to root_path
  end

  def current_order
    session[:order_id].nil? ? Order.new : Order.find(session[:order_id])
  end

  def ensure_signup_complete
    return if action_name == 'finish_signup'
    redirect_to finish_signup_path(current_user) if current_user && !current_user.email_verified?
  end

  def default_url_options(*)
    { locale: I18n.locale == I18n.default_locale ? nil : I18n.locale }
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def categories
    @categories = Category.all.order(default_sort: :desc)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password, :password_confirmation, :current_password) }
  end

end
