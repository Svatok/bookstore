class CheckoutsController < ApplicationController
  before_action :authenticate_user!
  before_action :initialize_order, :edit_order_data, :only => :show

  def show
    @partial = @order.state
#    @order.next_state
  return redirect_to root_path unless lookup_context.exists?(@partial, ["checkouts"], true)
  end

  def update
    @order = current_order
    @order.send(next_state + '_step')
    @order.save
    redirect_to checkouts_path
  end

  def initialize_order
    @order = current_order.decorate
    return unless @order.cart?
    @order[:user_id] = current_user.id
    @order.address_step
    @order.save
  end

  def edit_order_data
    @order_states = @order.aasm.states.map(&:name)
    @order.send(params['edit'] + '_step') if params['edit'].present? && @order_states.include?(params['edit'].to_sym)
    @order.save
  end

  def next_state
    return @order.prev_state if @order.prev_state == 'confirm'
    return 'complete' if @order.confirm?
    @order.aasm.states(permitted: true).map(&:name).first.to_s
  end

end
