class ProductReviewForm < Rectify::Form
  TEXT_REGEX = %r[[\p{L}]|[0-9]|[!#$%&'*+-\/=?^_`{|}~]]i
  attribute :user_id, Integer
  attribute :product_id, Integer
  attribute :rate, Integer
  attribute :reviewer_name, String
  attribute :review_text, String

  validates_presence_of :product_id, :rate, :reviewer_name, :review_text
  validates :rate, length: { is: 1 }, numericality: { greater_than_or_equal_to: 1,
                                                      less_than_or_equal_to: 5 }
  validates :reviewer_name, length: { maximum: 80 }, format: { with: TEXT_REGEX }
  validates :review_text, length: { maximum: 500 }, format: { with: TEXT_REGEX }
end
