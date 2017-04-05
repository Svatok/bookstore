require 'rails_helper'

RSpec.feature 'Checkout order delivery' do
  let(:user) { create :user_with_addresses }
  let(:order) { create :order_with_payment_state, state: 'payment' }
  let(:payment) { create :payment, order: order }

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

  context 'payment content' do
    scenario 'when filled go to next step' do
      fill_in 'payment_card_number', with: '1234123412341234'
      fill_in 'payment_name_on_card', with: 'Test User'
      fill_in 'payment_mm_yy', with: '12/22'
      fill_in 'payment_cvv', with: '122'
      click_button I18n.t('checkouts.show.save_and_continue')
      expect(page).to have_content(I18n.t('checkouts.confirm.edit'))
    end
    scenario 'when not filled show message with errors' do
      click_button I18n.t('checkouts.show.save_and_continue')
      expect(page).to have_content("Card number can't be blank")
      expect(page).to have_content("Name on card can't be blank")
      expect(page).to have_content("Mm yy can't be blank")
      expect(page).to have_content("Cvv can't be blank")
    end
  end
end
