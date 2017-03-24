class ProductPresenter < Rectify::Presenter
  attribute :review_form, ProductReviewForm, default: ProductReviewForm.new
  attribute :product_id, Product

  def product
    id = product_id || review_form.product_id
    Product.find(id).decorate
  end

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
