class PaymentForm < Rectify::Form
  attribute :card_number, String
  attribute :name_on_card, String
  attribute :mm_yy, String
  attribute :cvv, Integer

  validates :card_number, :name_on_card, :mm_yy, :cvv, :presence => true

end
