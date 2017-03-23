class UpdateOrderItems < Rectify::Command
  def initialize(options)
    @order = options[:object]
    @params = options[:params]
  end

  def call
    view_partial = @order.state
    return broadcast(:invalid) unless lookup_context.exists?(view_partial, ["checkouts"], true)
    initialize_new_order if new_valid_order?
    @order.send(@params['edit'] + '_step!') if editing_data?
    broadcast(:ok, @order.decorate, view_partial, presenter)
  end
end
  
