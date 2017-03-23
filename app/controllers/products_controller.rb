class ProductsController < ApplicationController
  helper ProductsHelper

  def index
    @all_sort_params = ProductsHelper::SORTING
    @products = SorteredProducts.new(params)
    @order_item = current_order.order_items.new
  end

  def show
    present ProductPresenter.new(product: Product.find(params[:id]).decorate)
  end

end
