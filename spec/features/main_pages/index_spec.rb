require 'rails_helper'

RSpec.feature 'Home page:' do
  let(:categories) { create_list :category, 3 }
  let(:order) { create :order }
  let(:locale) { :en }


  before do
    categories.each do |category|
      create_list :product, 5, :with_orders, category: category
    end
    I18n.locale = locale
    default_category = Category.all.first
    default_category.default_sort = true
    default_category.save
    page.set_rack_session(order_id: order.id)
    visit('/')
  end

  scenario 'located on home page' do
    expect(page).to have_current_path root_path
  end

  context 'main content' do
    scenario 'must present 2 newest products' do
      expect(page).to have_css('.item', count: 2, visible: :all)
    end
    scenario 'must present 4 bestsellers' do
      expect(page).to have_selector('.general-title', count: 4)
    end
  end

  context 'working buttons' do
    scenario 'add newest product to cart' do
      click_link I18n.t('main_pages.home.buy_now')
      expect(page).to have_content('Your cart was updated!')
    end
    scenario 'add bestseller to cart change total price of order' do
      first('.fa-shopping-cart', visible: :all).click
      expect(page).to have_content('Your cart was updated!')
    end
    scenario 'show product' do
      first('.fa-eye', visible: :all).click
      expect(page).to have_current_path(/products\/[0-9]+/)
    end
    scenario 'click Get Started button' do
      click_link I18n.t('main_pages.home.get_started')
      expect(page.status_code).to eq(200)
      expect(page).to have_current_path('/products')
    end
  end
end
