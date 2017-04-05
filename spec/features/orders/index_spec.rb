require 'rails_helper'

RSpec.feature 'Orders page' do
  let(:user) { create :user }

  before do
    login_as(user, scope: :user)
    create_list :full_order, 3, user: user, state: 'in_waiting', order_number: "R0000TEST#{rand(6)}", placed_date: Date.today
    visit orders_path
  end

  scenario 'redirect to Log In if user is unauthorized' do
    logout(:user)
    visit orders_path
    expect(page).to have_current_path('/users/login')
  end

  context 'orders content' do
    scenario 'must present title of orders page' do
      expect(page).to have_content I18n.t('orders.index.my_orders')
    end
    scenario 'must present order items' do
      expect(page).to have_selector('.general-order-number', count: 3)
      user.orders.each do |order|
        expect(page).to have_content(order.order_number)
      end
    end
    scenario 'must present working link to show order' do
      first('.general-order-number').click
      expect(page).to have_current_path(/orders\/[0-9]+/)
    end
  end

end
