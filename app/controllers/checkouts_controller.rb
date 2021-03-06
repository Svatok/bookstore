class CheckoutsController < ApplicationController
  include Rectify::ControllerHelpers

  before_action :authenticate_user!, :prepare_checkout, :ensure_signup_complete
  after_action :complete_order, only: [:show]

  def show
  end

  def update
    "Set#{@order.state.capitalize}".constantize.call(options) do
      on(:ok) { |order| order.send(order.next_state + '_step!') and redirect_to checkouts_path }
      on(:invalid) { |object_with_errors| expose(object: object_with_errors) and render :show }
    end
  end

  private

  def prepare_checkout
    PrepareCheckout.call(options) do
      on(:ok) do |order, view_partial, presenter|
        expose(order: order, view_partial: view_partial)
        present "#{presenter.camelize}Presenter".constantize.new(object: order)
      end
      on(:invalid) { redirect_to root_path }
    end
  end

  def options
    { object: current_order, params: params }
  end

  def complete_order
    return unless @order.complete?
    @order.in_waiting_step
  end
end
