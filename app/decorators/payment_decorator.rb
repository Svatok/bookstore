class PaymentDecorator < Draper::Decorator
  delegate_all

  def four_numbers_of_card
    '** ** **' + card_number.last(4)
  end

end
