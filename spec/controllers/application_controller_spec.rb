require 'rails_helper'

describe ApplicationController, type: :controller do
  describe '#current_order' do
    it 'get current order from exist session' do
      order = create :order
      session[:order_id] = order.id
      expect(controller.current_order).to eq(order)
    end
    it 'create new order' do
      expect(controller.current_order).to be_present
    end
  end
end
