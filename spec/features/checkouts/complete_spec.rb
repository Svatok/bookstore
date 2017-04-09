require 'rails_helper'

RSpec.feature 'Checkout order complete' do
  let(:user) { create :user_with_addresses }
  let(:order) { create :full_order, state: 'complete', order_number: 'R0000TEST', placed_date: Date.today}

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

  context 'order complete content' do
    scenario 'must present message about sending letter' do
      expect(page).to have_content I18n.t('checkouts.complete.order_confirmation')
    end
    scenario 'must present short shipping address' do
      expect(page).to have_content(order.addresses.address_with_type('shipping').first_name)
      expect(page).to have_content(order.addresses.address_with_type('shipping').last_name)
      expect(page).to have_content(order.addresses.address_with_type('shipping').address)
      expect(page).to have_content(order.addresses.address_with_type('shipping').city)
      expect(page).to have_content(order.addresses.address_with_type('shipping').country.name)
      expect(page).to have_content(order.addresses.address_with_type('shipping').zip)
      expect(page).to have_content(order.addresses.address_with_type('shipping').phone)
    end
    scenario 'must present placed order informat' do
      expect(page).to have_content order.order_number
    end
    scenario 'must present order items' do
      expect(page).to have_selector('.general-title', count:2)
      order.order_items.only_products.each do |order_item|
        expect(page).to have_content(order_item.product.title)
      end
    end
    scenario 'must present coupon price' do
      coupon_price = order.order_items.only_coupons.first.product.prices.actual.first.value
      expect(first('.general-summary-table')).to have_content((coupon_price * -1).to_s)
    end
    scenario 'must present shipping price' do
      shipping_price = order.order_items.only_shippings.first.product.prices.actual.first.value
      expect(first('.general-summary-table')).to have_content(shipping_price.to_s)
    end
    scenario 'must present total price' do
      expect(first('.general-summary-table')).to have_content(order.total_price.to_s)
    end
    scenario 'redirect to root path after confirm' do
      click_button 'Back to Store'
      expect(page).to have_current_path("/")
    end
  end


end
