class SetConfirm < Rectify::Command
  def initialize(options)
    @object = options[:object]
  end

  def call
    return broadcast(:invalid, @object) unless place_order
    OrderMailer.order_complete(@object, current_user).deliver
    broadcast(:ok, @object)
  end

  private

  def place_order
    @object.update_attributes(order_number: new_order_number, placed_date: Date.today)
  end

  def new_order_number
    "R%.8d" % @object.id
  end
end
