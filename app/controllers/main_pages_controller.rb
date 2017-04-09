class MainPagesController < ApplicationController
  def home
    category_sort = params[:category].present? ? params[:category] : @categories.default_sort.first
    @products = Product.with_category(category_sort)
    @lattest_products = @products.lattest_products(2).decorate
    @best_sellers = @products.best_sellers.limit(4).decorate
  end
end
