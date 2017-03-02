class ReviewsController < ApplicationController

  def create
    @user = current_user || User.new
    @product = ProductDecorator.new(Product.find(params[:product_review][:product_id]))
    @reviews = @product.reviews.approved
    @review_form = ProductReviewForm.from_params(params)
    if @review_form.valid?
      Review.create(@review_form.attributes)
      redirect_to product_path(@product), notice: 'Thanks for Review. It will be published as soon as Admin will approve it.'
    else
      render :template => 'products/show'
    end
  end

end
