require 'rails_helper'

RSpec.feature 'Order show' do
  let(:user) { create :user_with_addresses }
  let(:order) { create :full_order, state: 'confirm' }

  before do
    login_as(user, scope: :user)
    page.set_rack_session(order_id: order.id)
    visit checkouts_path
  end

  scenario 'redirect to Log In if user is unauthorized' do
    logout(:user)
    visit checkouts_path
    expect(page).to have_current_path('/users/login')
  end

  context 'order content' do
    scenario 'must present short billing address' do
      expect(page).to have_content(order.addresses.billing.first.first_name)
      expect(page).to have_content(order.addresses.billing.first.last_name)
      expect(page).to have_content(order.addresses.billing.first.address)
      expect(page).to have_content(order.addresses.billing.first.city)
      expect(page).to have_content(order.addresses.billing.first.country.name)
      expect(page).to have_content(order.addresses.billing.first.zip)
      expect(page).to have_content(order.addresses.billing.first.phone)
    end
    scenario 'must present short shipping address' do
      expect(page).to have_content(order.addresses.shipping.first.first_name)
      expect(page).to have_content(order.addresses.shipping.first.last_name)
      expect(page).to have_content(order.addresses.shipping.first.address)
      expect(page).to have_content(order.addresses.shipping.first.city)
      expect(page).to have_content(order.addresses.shipping.first.country.name)
      expect(page).to have_content(order.addresses.shipping.first.zip)
      expect(page).to have_content(order.addresses.shipping.first.phone)
    end
    scenario 'must present short shipment information' do
      expect(page).to have_content(order.order_items.only_shippings.first.product.title)
      expect(page).to have_content(order.order_items.only_shippings.first.product.description)
    end
    scenario 'must present short payment information' do
      expect(page).to have_content(order.payments.first.mm_yy)
      expect(page).to have_content(order.payments.first.card_number.last(4))
    end
    scenario 'must present order items' do
      expect(page).to have_selector(".general-title", count:2)
      order.order_items.only_products.each do |order_item|
        expect(page).to have_content(order_item.product.title)
      end
    end
    scenario 'must present coupon price' do
      coupon_price = order.order_items.only_coupons.first.product.prices.actual.first.value
      expect(first('.general-summary-table')).to have_content((coupon_price*-1).to_s)
    end
    scenario 'must present shipping price' do
      shipping_price = order.order_items.only_shippings.first.product.prices.actual.first.value
      expect(first('.general-summary-table')).to have_content(shipping_price.to_s)
    end
    scenario 'must present total price' do
      expect(first('.general-summary-table')).to have_content(order.total_price.to_s)
    end
  end
end
