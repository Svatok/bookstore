class ProductReviewForm < Rectify::Form
  attribute :user_id, Integer
  attribute :product_id, Integer
  attribute :rate, Integer
  attribute :reviewer_name, String
  attribute :review_text, String

  validates :product_id, :rate, :reviewer_name, :review_text, :presence => true
end
