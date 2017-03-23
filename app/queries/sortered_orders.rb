class SorteredOrders < Rectify::Query
  helper PaginationHelper

  def initialize(orders, params)
    @params = params
    @params[:sort] = 'in_waiting' unless @params[:sort].present?
    @page = @params[:page].present? ? @params[:page].to_i : 1
    @limit = 20
    @orders = orders
  end

  def query
    @orders.where(state: @params[:sort]).limit(@limit).offset(offset)
  end
end
