class CheckoutsController < ApplicationController
  include Rectify::ControllerHelpers

  before_action :authenticate_user!, :prepare_checkout, :ensure_signup_complete
  after_action :complete_order, only [:show]

  def show
  end

  def update
    "Set#{@order.state.capitalize}".constantize.call(options) do
      on(:ok) do
        # send(@order.state + '_update!')
        redirect_to checkouts_path
      end
      on(:invalid) { |forms| expose(object: object_with_errors) and render :show }
    end
  end

  private

  def prepare_checkout
    PrepareCheckout.call(options) do
      on(:ok) do |order, view_partial|
        expose(order: order, view_partial: view_partial)
        present "#{order.state.capitalize}Presenter".constantize.new(object: order)
      end
      on(:invalid) { redirect_to root_path }
    end
  end

  def options
    { object: current_order, params: params }
  end
 
  def complete_order
    return unless @order.confirm?
    @order.complete_step
  end
  
  def next_state
    return @order.prev_state if @order.prev_state == 'confirm' && @order.state != 'complete'
    return 'complete' if @order.confirm?
    @order.aasm.states(permitted: true).map(&:name).first.to_s
  end

end
