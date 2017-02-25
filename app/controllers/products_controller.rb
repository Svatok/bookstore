class ProductsController < ApplicationController
  helper ProductsHelper

  def index
    @products = SorteredProducts.new(params)
  end

  def show
    @product = ProductDecorator.new(Product.find(params[:id]))
  end
end
