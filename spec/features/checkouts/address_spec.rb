require 'rails_helper'

RSpec.feature 'Checkout order address' do
  let(:user) { create :user_with_addresses }
  let(:order) { create :order, :with_items, state: 'address' }

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

  context 'address information content' do
    scenario 'adress forms filled by present user addresses' do
      click_button I18n.t('checkouts.show.save_and_continue')
      expect(page).to have_content(I18n.t('checkouts.delivery.shipping_method'))
    end
    scenario 'shipping addres filled by checkbox Use Billing Address' do
      user.addresses.address_with_type('shipping').destroy
      visit checkouts_path
      find('.checkbox-icon').click
      click_button I18n.t('checkouts.show.save_and_continue')
      expect(page).to have_content(I18n.t('checkouts.delivery.shipping_method'))
    end
    scenario 'billing form not filled' do
      user.addresses.address_with_type('billing').destroy
      visit checkouts_path
      click_button I18n.t('checkouts.show.save_and_continue')
      expect(page).to have_content("First name can't be blank")
      expect(page).to have_content("Last name can't be blank")
      expect(page).to have_content("Address can't be blank")
      expect(page).to have_content("City can't be blank")
      expect(page).to have_content("Zip can't be blank")
      expect(page).to have_content("Phone can't be blank")
    end
    scenario 'shipping form not filled' do
      user.addresses.address_with_type('shipping').destroy
      visit checkouts_path
      click_button I18n.t('checkouts.show.save_and_continue')
      expect(page).to have_content("First name can't be blank")
      expect(page).to have_content("Last name can't be blank")
      expect(page).to have_content("Address can't be blank")
      expect(page).to have_content("City can't be blank")
      expect(page).to have_content("Zip can't be blank")
      expect(page).to have_content("Phone can't be blank")
    end
  end
end
