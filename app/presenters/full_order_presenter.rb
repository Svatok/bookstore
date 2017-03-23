class FullOrderPresenter < Rectify::Presenter
  attribute :object
  
  def current_payment_form
    form_has_errors? ? object : form_without_errors
  end
  
  private
  
  def form_has_errors?
    object.is_a?(PaymentForm)
  end

  def form_without_errors
    object.payments.present? ? PaymentForm.from_model(object.payments.first) : new_payment
  end
end
