class ProductPresenter < Rectify::Presenter
  attribute :review_form, ProductReviewForm, :default => ProductReviewForm.new
  attribute :product, Product, :default => Product.find(review_form.product_id]).decorate
  
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
