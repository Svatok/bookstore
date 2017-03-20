require 'rails_helper'

describe AddressesController, type: :controller do
  describe 'GET #create' do
    let(:user) { create :user }

    before do
      sign_in user
    end

    it 'create user billing address' do
      billing_address = create :billing_address
      billing_attributes = billing_address.attributes
      params = { address_forms: { billing: billing_attributes }, billing: 'true' }
      expect { get :create, params: params }.to change { user.addresses.count }.by(1)
    end

    it 'update user billing address' do
      billing_address = create :billing_address, addressable: user
      billing_attributes = billing_address.attributes
      billing_attributes[:first_name] = 'New First Name'
      params = { address_forms: { billing: billing_attributes }, billing: 'true' }
      expect { get :create, params: params }.to_not change { user.addresses.count }
      expect(billing_address[:first_name]).to_not eq(user.addresses.billing.first[:first_name])
      expect(user.addresses.billing.first[:first_name]).to eq('New First Name')
    end

    it 'create user shipping address' do
      shipping_address = create :shipping_address
      shipping_attributes = shipping_address.attributes
      params = { address_forms: { shipping: shipping_attributes }, shipping: 'true' }
      expect { get :create, params: params }.to change { user.addresses.count }.by(1)
    end

    it 'update user shipping address' do
      shipping_address = create :shipping_address, addressable: user
      shipping_attributes = shipping_address.attributes
      shipping_attributes[:first_name] = 'New First Name'
      params = { address_forms: { shipping: shipping_attributes }, shipping: 'true' }
      expect { get :create, params: params }.to_not change { user.addresses.count }
      expect(shipping_address[:first_name]).to_not eq(user.addresses.shipping.first[:first_name])
      expect(user.addresses.shipping.first[:first_name]).to eq('New First Name')
    end

  end
end
