require 'rails_helper'

describe CartsController, type: :controller do
  describe 'GET #show' do
    let(:order) { create :order, :with_items }

    before do
      session[:order_id] = order.id
      get :show
    end

    it 'render :cart template' do
      expect(response).to render_template :show
    end
    it 'respond with 200 status code' do
      expect(response).to have_http_status(200)
    end
    it '@order must be present' do
      expect(assigns(:order)).to be_present
    end
    it '@order_items must be present' do
      expect(assigns(:order_items)).to be_present
    end
  end

  describe 'PATCH #update' do
    let(:order) { create :order, :with_items }

    before do
      session[:order_id] = order.id
    end

    it 'with change product count' do
      order_params = { order_items: { "#{Order.find(order.id).order_items.first.id}" => { quantity: '3' } }, coupon: {code: ''} }
      expect { put :update, params: order_params }.to change { Order.find(order.id).total_price }
    end
    it 'with coupon add' do
      coupon = create :product, :coupon
      order_params = { order_items: { "#{Order.find(order.id).order_items.first.id}" => { quantity: '3' } }, coupon: {code: coupon.title} }
      expect { put :update, params: order_params }.to change { Order.find(order.id).total_price }
    end
  end
end
