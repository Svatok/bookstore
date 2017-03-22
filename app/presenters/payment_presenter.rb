class PaymentPresenter < Rectify::Presenter
  attribute :objects
  attribute :new_payment, PaymentForm, :default => PaymentForm.new
  
  def current_payment_form
    forms_has_errors? ? form_with_errors : form_without_errors
  end
  
  private
  
  def form_with_errors
    objects.first
  end
  
  def forms_has_errors?
    objects.is_a?(Hash)
  end

  def form_without_errors
    objects.present? ? PaymentForm.from_model(objects.first) : new_payment
  end
end
