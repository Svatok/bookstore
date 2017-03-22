class PrepareCheckout < Rectify::Command
  def initialize(options)
    @order = options[:object]
    @params = options[:params]
  end

  def call
    @view_partial = @order.state
    return broadcast(:invalid) unless lookup_context.exists?(@view_partial, ["checkouts"], true)
    initialize_new_order if new_valid_order?
    @order.send(@params['edit'] + '_step!') if editing_data?
    broadcast(:ok, @order.decorate, @view_partial)
  end

  private

  def new_valid_order?
    @order.cart? && @order.total_price > 0
  end

  def initialize_new_order
    @order[:user_id] = current_user.id
    @order.address_step!
  end

  def editing_data?
    @params['edit'].present? && @order.aasm.states.map(&:name).include?(@params['edit'].to_sym)
  end
end
