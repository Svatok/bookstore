class PaymentForm < Rectify::Form
  attribute :card_number, String
  attribute :name_on_card, String
  attribute :mm_yy, String
  attribute :cvv, Integer

  validates_presence_of :card_number, :name_on_card, :mm_yy, :cvv
  validates :card_number, format: { with: /\A[0-9]{16}\z/ }, length: { maximum: 16 }
  validates :name_on_card, format: { with: /[a-z]/i }, length: { maximum: 50 }
  validates :mm_yy, format: { with: /\A((0[1-9])|(1[0-2]))\/([0-9]{2})\z/ }, length: { maximum: 5 }
  validates :cvv, format: { with: /\A[0-9]{3,4}\z/ }, length: { in: 3..4 }

end
