require 'rails_helper'

describe MainPagesController, type: :controller do
  describe 'GET #home' do
    before do
      categories = create_list :category, 3
      categories.each do |category|
        create_list :product, 5, :with_orders, category: category
      end
      get :home
    end

    it 'render :home template' do
      expect(response).to render_template :home
    end

    it 'respond with 200 status code' do
      expect(response).to have_http_status(200)
    end

    it '@products must be present' do
      expect(assigns(:products)).not_to be_nil
    end

    it '@lattest_products must be present' do
      expect(assigns(:lattest_products)).not_to be_nil
    end

    it '@best_sellers must be present' do
      expect(assigns(:best_sellers)).not_to be_nil
    end
  end
end
