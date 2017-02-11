class MainPagesController < ApplicationController
  def home
    @lattest_books = ProductsController.new.lattest_books(3)
  end
end
