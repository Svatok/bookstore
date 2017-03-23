class ReviewsController < ApplicationController

  def create
    review_form = ProductReviewForm.from_params(params)
    present ProductPresenter.new(review_form: review_form)
    return render :template => 'products/show' unless review_form.valid?
    Review.create(review_form.attributes)
    flash[:success] = 'Thanks for Review. It will be published as soon as Admin will approve it.'
    redirect_to product_path(@product)
  end

end
