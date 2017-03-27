class SorteredOrders < Rectify::Query
  include PaginationHelper

  def initialize(orders, params)
    @params = params
    @params[:sort] = 'in_waiting' unless @params[:sort].present?
    @page = @params[:page].present? ? @params[:page].to_i : 1
    @limit = 20
    @orders = orders
  end

  def query
    @orders.where(state: @params[:sort]).order(created_at: :desc).limit(@limit).offset(offset)
  end

  def total_pages
    total = query.to_a.size
    (total.to_f / @limit).ceil
  end
end
