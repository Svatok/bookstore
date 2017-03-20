require 'rails_helper'

describe OrdersController, type: :controller do
  describe 'GET #index' do
    let(:user) { create :user }
    let(:orders) { create_list :full_order, 3, user: user }

    before do
      sign_in user
      get :index
    end

    it 'render :index template' do
      expect(response).to render_template :index
    end
    it 'respond with 200 status code' do
      expect(response).to have_http_status(200)
    end
    it '@orders must be present' do
      expect(assigns(:orders)).to be_present
    end
  end

  describe 'GET #show' do
    let(:user) { create :user }
    let(:order) { create :full_order, user: user }

    before do
      sign_in user
      get :show, params: { id: order.id }
    end

    it 'render :show template' do
      expect(response).to render_template :show
    end
    it 'respond with 200 status code' do
      expect(response).to have_http_status(200)
    end
    it '@order must be present' do
      expect(assigns(:order)).to be_present
    end
    it '@shipping_address must be present' do
      expect(assigns(:shipping_address)).to be_present
    end
    it '@billing_address must be present' do
      expect(assigns(:billing_address)).to be_present
    end
    it '@shipping must be present' do
      expect(assigns(:shipping)).to be_present
    end
    it '@payment must be present' do
      expect(assigns(:payment)).to be_present
    end
    it '@order_items must be present' do
      expect(assigns(:order_items)).to be_present
    end
  end

  describe 'GET #cart' do
    let(:order) { create :order, :with_items }

    before do
      session[:order_id] = order.id
      get :cart
    end

    it 'render :cart template' do
      expect(response).to render_template :cart
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

  describe 'PATCH #update_cart' do
    let(:order) { create :order, :with_items }

    before do
      session[:order_id] = order.id
    end

    it 'with change product count' do
      order_params = { order_items: { "#{Order.find(order.id).order_items.first.id}" => { quantity: '3' } }, coupon: {code: ''} }
      expect { put :update_cart, params: order_params }.to change { Order.find(order.id).total_price }
    end
    it 'with coupon add' do
      coupon = create :product, :coupon
      order_params = { order_items: { "#{Order.find(order.id).order_items.first.id}" => { quantity: '3' } }, coupon: {code: coupon.title} }
      expect { put :update_cart, params: order_params }.to change { Order.find(order.id).total_price }
    end
  end
end
