class ProductsController < ApplicationController
  helper ProductsHelper

  def index
    @products = params[:category].nil? ? Product.in_stock : Product.with_category(params[:category])
    @products = SorteredProducts.new(params[:sort]) unless params[:sort].nil?
  end
end
