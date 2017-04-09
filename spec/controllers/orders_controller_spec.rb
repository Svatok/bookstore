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
  end
end
