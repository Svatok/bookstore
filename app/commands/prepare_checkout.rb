class PrepareCheckout < Rectify::Command
  def initialize(options)
    @order = options[:object]
    @params = options[:params]
  end

  def call
    initialize_new_order if new_valid_order?
    @order.send(@params['edit'] + '_step!') if editing_data?
    @view_partial = @order.state
    place_order if @view_partial == 'complete'
    return broadcast(:invalid) unless lookup_context.exists?(@view_partial, ["checkouts"], true)
    broadcast(:ok, @order.decorate, @view_partial, presenter)
  end

  private

  def new_valid_order?
    return false unless @order.total_price.present?
    @order.cart? && @order.total_price > 0
  end

  def initialize_new_order
    @order[:user_id] = current_user.id
    @order.address_step!
  end

  def editing_data?
    @params['edit'].present? && @order.aasm.states.map(&:name).include?(@params['edit'].to_sym)
  end

  def presenter
    return 'full_order' if @view_partial == 'confirm' || @view_partial == 'complete'
    @view_partial
  end

  def place_order
    @order.in_waiting_step!
    session.delete(:order_id)
  end
end
