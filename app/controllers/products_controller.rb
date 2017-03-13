class ProductsController < ApplicationController
  helper ProductsHelper

  def index
    @all_sort_params = ProductsHelper::SORTING
    @products = SorteredProducts.new(params)
    @order_item = current_order.order_items.new
  end

  def show
    @user = current_user || User.new
    @product = Product.find(params[:id]).decorate
    @reviews = @product.reviews.approved.decorate
    @review_form = ProductReviewForm.new
    @order_item = current_order.order_items.new
  end

  private

  def order_item_params
    params.require(:order_item).permit(:quantity, :product_id)
  end

end
