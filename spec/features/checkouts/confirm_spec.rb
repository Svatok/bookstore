require 'rails_helper'

RSpec.feature 'Checkout order confirm' do
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

  context 'order confirm content' do
    scenario 'must present short billing address' do
      expect(page).to have_content(order.addresses.address_with_type('billing').first.first_name)
      expect(page).to have_content(order.addresses.address_with_type('billing').first.last_name)
      expect(page).to have_content(order.addresses.address_with_type('billing').first.address)
      expect(page).to have_content(order.addresses.address_with_type('billing').first.city)
      expect(page).to have_content(order.addresses.address_with_type('billing').first.country.name)
      expect(page).to have_content(order.addresses.address_with_type('billing').first.zip)
      expect(page).to have_content(order.addresses.address_with_type('billing').first.phone)
    end
    scenario 'must present short shipping address' do
      expect(page).to have_content(order.addresses.address_with_type('shipping').first.first_name)
      expect(page).to have_content(order.addresses.address_with_type('shipping').first.last_name)
      expect(page).to have_content(order.addresses.address_with_type('shipping').first.address)
      expect(page).to have_content(order.addresses.address_with_type('shipping').first.city)
      expect(page).to have_content(order.addresses.address_with_type('shipping').first.country.name)
      expect(page).to have_content(order.addresses.address_with_type('shipping').first.zip)
      expect(page).to have_content(order.addresses.address_with_type('shipping').first.phone)
    end
    scenario 'must present short shipment information' do
      expect(page).to have_content(order.order_items.only_shippings.first.product.title)
      expect(page).to have_content(order.order_items.only_shippings.first.product.description)
    end
    scenario 'must present short payment information' do
      expect(page).to have_content(order.payments.first.mm_yy)
      expect(page).to have_content(order.payments.first.card_number.last(4))
    end
    scenario 'must present edit information links' do
      expect(page).to have_css(".general-edit", count: 4)
    end
    scenario 'must present order items' do
      expect(page).to have_selector(".general-title", count:2)
      order.order_items.only_products.each do |order_item|
        expect(page).to have_content(order_item.product.title)
      end
    end
    scenario 'redirect to comlete page after confirm' do
      click_button 'Save and Continue'
      expect(page).to have_content("Thank You for your Order!")
    end
    scenario 'send letter after confirm' do
      clear_emails
      click_button 'Save and Continue'
      placed_order = Order.find(order.id)
      open_email(user.email)
      expect(current_email).to have_content placed_order.order_number
    end
  end


end
