class ReviewsController < ApplicationController

  def create
    @user = current_user || User.new
    @product = Product.find(params[:product_review][:product_id]).decorate
    @reviews = @product.reviews.approved.decorate
    @review_form = ProductReviewForm.from_params(params)
    @order_item = current_order.order_items.new
    if @review_form.valid?
      Review.create(@review_form.attributes)
      flash[:success] = 'Thanks for Review. It will be published as soon as Admin will approve it.'
      redirect_to product_path(@product)
    else
      render :template => 'products/show'
    end
  end

end
