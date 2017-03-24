class ProductsController < ApplicationController
  helper ProductsHelper
  helper PicturesHelper
  include Rectify::ControllerHelpers

  def index
    @all_sort_params = ProductsHelper::SORTING
    @products = SorteredProducts.new(params)
    @order_item = current_order.order_items.new
  end

  def show
    present ProductPresenter.new(product_id: params[:id])
  end
end
