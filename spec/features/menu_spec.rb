require 'rails_helper'

RSpec.feature 'Menu panel' do
  let(:categories) { create_list :category, 3 }
  before { visit root_path }

  scenario 'Home link must present' do
    expect(page).to have_content I18n.t('layouts.header.home')
  end
  scenario 'must present working Shop link' do
    first('a', text: I18n.t('layouts.header.shop')).click
    expect(page).to have_current_path('/products')
  end

  context 'guest visit' do
    scenario 'must present working Log In link' do
      first('a', text: I18n.t('layouts.header.log_in')).click
      expect(page).to have_current_path('/users/login')
    end
    scenario 'must present working Sign Up link' do
      first('a', text: I18n.t('layouts.header.sign_up')).click
      expect(page).to have_current_path('/users/sign_up')
    end
  end

  context 'signed user visit' do
    let(:user) { create :user }

    before do
      user.confirmed_at = Time.now
      user.save
      login_as(user, scope: :user)
      visit root_path
    end

    scenario 'link to My account must present' do
      expect(page).to have_content I18n.t('layouts.header.my_account')
    end
    scenario 'must present working link Orders' do
      click_link I18n.t('layouts.header.my_account')
      first('a', text: I18n.t('layouts.header.orders')).click
      expect(page).to have_current_path('/orders')
    end
    scenario 'must present working link Settings' do
      click_link I18n.t('layouts.header.my_account')
      first('a', text: I18n.t('layouts.header.settings')).click
      expect(page).to have_current_path('/users/edit')
    end
    scenario 'must present working link Log out' do
      click_link I18n.t('layouts.header.my_account')
      first('a', text: I18n.t('layouts.header.log_out')).click
      expect(page).to have_content(I18n.t('layouts.header.log_in'))
    end
  end

  context 'link to Cart' do
    let(:order) { create :order, :with_items }

    scenario 'must present working link to Cart page' do
      find('.shop-icon').click
      expect(page).to have_current_path('/cart')
    end
    scenario 'not show count of products in cart when cart empty' do
      expect(page).to have_no_selector '.shop-quantity'
    end
    scenario 'show count of products in cart when cart not empty' do
      page.set_rack_session(order_id: order.id)
      visit root_path
      expect(page).to have_selector('.shop-quantity', text: order.order_items.count.to_s)
    end
  end
end
