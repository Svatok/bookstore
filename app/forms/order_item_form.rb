class OrderItemForm < Rectify::Form
  attribute :product_id, Integer
  attribute :quantity, Integer

  validates :product_id, :quantity, :presence => true
end
