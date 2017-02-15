class MainPagesController < ApplicationController
  def home
    @lattest_products = Product.lattest_products(3)
    @best_sellers = Product.best_sellers(4)
  end
end
