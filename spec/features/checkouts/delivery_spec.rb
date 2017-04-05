require 'rails_helper'

RSpec.feature 'Checkout order delivery' do
  let(:user) { create :user_with_addresses }
  let(:order) { create :order, :with_items, state: 'delivery' }

  before do
    login_as(user, scope: :user)
    create_list :product, 3, :shipping
    page.set_rack_session(order_id: order.id)
    visit checkouts_path
  end

  scenario 'redirect to Log In if user is unauthorized' do
    logout(:user)
    visit checkouts_path
    expect(page).to have_current_path('/users/login')
  end

  context 'delivery check content' do
    scenario 'deliveries must be present' do
      expect(page).to have_selector('.radio-text', count: 3)
    end
    scenario 'delivery checked' do
      first('.radio-icon').click
      click_button I18n.t('checkouts.show.save_and_continue')
      expect(page).to have_content(I18n.t('checkouts.payment.credit_card'))
    end
    scenario 'delivery not checked' do
      click_button I18n.t('checkouts.show.save_and_continue')
      expect(page).to have_content('Choose delivery!')
    end
  end

end
