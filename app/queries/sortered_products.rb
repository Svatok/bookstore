class SorteredProducts < Rectify::Query
  include PaginationHelper

  def initialize(params)
    @params = params
    @params[:sort] = 'newest' unless @params[:sort].present?
    @page = @params[:page].present? ? @params[:page].to_i : 1
    @limit = 12
    @products = Product.in_stock
  end

  def query
    all.limit(@limit).offset(offset).decorate
  end

  def total_pages
    all.to_a.size / @limit
  end

  private

  def all
    @products = @products.where(category: @params[:category]) if @params[:category].present?
    @products = @products.send(@params[:sort]) if @products.respond_to?(@params[:sort])
    @products
  end
end
