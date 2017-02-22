class ProductsController < ApplicationController
  helper ProductsHelper

  def index
    @products = SorteredProducts.new(params)
#    @products = Product.all.page params[:page]
  end
end
