require 'rails_helper'

describe ReviewsController, type: :controller do
  describe 'GET #create' do
    let(:user) { create :user }
    let(:product) { create :full_product }

    it 'create review by guest' do
      review = product.reviews.first
      review[:id] = nil
      params = { product_review: review.attributes }
      expect { get :create, params: params }.to change { product.reviews.count }.by(1)
    end
  end
end
