class ProductsController < ApplicationController
  helper ProductsHelper

  def index
    @products = SorteredProducts.new(params)
  end

  def show
    @user = current_user || User.new
    @product = ProductDecorator.new(Product.find(params[:id]))
    @reviews = @product.reviews.approved.decorate
    @review_form = ProductReviewForm.new
  end
end
