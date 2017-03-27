class SetPayment < Rectify::Command
  def initialize(options)
    @params = options[:params]
    @object = options[:object]
  end

  def call
    payment_form = PaymentForm.from_params(permit_params)
    return broadcast(:invalid, payment_form) unless payment_form.valid?
    set_payment(payment_form)
    broadcast(:ok, @object)
  end

  private

  def set_payment(payment_form)
    @object.payments.first_or_initialize.update_attributes(payment_form.attributes)
  end

  def permit_params
    @params.permit(payment: [:card_number, :name_on_card, :mm_yy, :cvv])
  end
end
