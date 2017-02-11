class ProductsController < ApplicationController
    def lattest_books(books_count)
      Product.all.order(created_at: :desc).limit(books_count)
    end

    def best_sellers(books_count)
      Product.all.limit(books_count)
    end
end
