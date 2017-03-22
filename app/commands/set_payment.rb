class SetPayment < Rectify::Command
  def initialize(options)
    @params = options[:params]
    @object = options[:object]
    @payment_forms = {}
  end
  
  def call
    payment_form = PaymentForm.from_params(permit_params)
    return set_payment(payment_form) and broadcast(:ok) if payment_form.valid?
    @payment_forms[:main] = payment_form
    broadcast(:invalid, @payment_forms)
  end

  private

  def set_payment(payment_form)
    @object.payments.first_or_initialize.update_attributes(payment_form.attributes)
  end

  def permit_params
    @params.permit(payment: [:card_number, :name_on_card, :mm_yy, :cvv])
  end
end
