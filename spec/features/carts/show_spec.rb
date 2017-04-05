require 'rails_helper'

RSpec.feature 'Cart' do
  let(:user) { create :user }
  let(:order) { create :order, :with_items }
  let(:coupon) { create :product, :coupon }

  before do
    login_as(user, scope: :user)
    page.set_rack_session(order_id: order.id)
    visit cart_path
    @cart = Order.all.find(order.id)
  end

  context 'cart content' do
    scenario 'must present order_items' do
      @cart.order_items.each do |order_item|
        expect(page).to have_content(order_item.product.title)
      end
    end
    scenario 'cart total price must equal sum(count * unit_price) of order_items' do
      expect(first('.general-summary-table')).to have_content(@cart.total_price.to_s)
    end
    scenario 'update with coupon' do
      fill_in 'coupon_code', with: coupon.title
      click_button I18n.t('carts.show.update_cart')
      expect(first('.general-summary-table')).to have_content((coupon.price_value * -1).to_s)
    end
    scenario 'update with add quantity of order item' do
      fill_in 'order_items_' + @cart.order_items.first.id.to_s + '_quantity', with: '3'
      click_button I18n.t('carts.show.update_cart')
      expect(first('.general-summary-table')).to have_content(@cart.total_price.to_s)
    end
    scenario 'delete order item' do
      first('.general-cart-close').click
      expect(first('.general-summary-table')).to have_content(@cart.total_price)
    end
  end

  scenario 'go to checkout' do
    click_link I18n.t('carts.show.checkout')
    expect(page).to have_current_path('/checkouts')
  end
end
