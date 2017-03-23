class ProductPresenter < Rectify::Presenter
  attribute :product
  attribute :new_review, ProductReviewForm, :default => ProductReviewForm.new
  
  def user
    current_user || User.new
  end
  
  def reviews
    product.reviews.approved.decorate
  end  

  def order_item
    current_order.order_items.new 
  end  
end
