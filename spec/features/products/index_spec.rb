require 'rails_helper'

RSpec.feature '/products' do
  let(:categories) { create_list :category, 3 }
  let(:order) { create :order }

  before do
    categories.each do |category|
      create_list :product, 3, category: category
    end
    page.set_rack_session(order_id: order.id)
    visit products_path
  end

  context 'main content' do
    scenario 'count of products < max visible products at page' do
      expect(page).to have_selector('.general-title', count: 9)
      expect(page).to have_no_selector('.btn-primary', text: I18n.t(:next_page))
    end
    scenario 'count of products > max visible products at page' do
      categories.each do |category|
        create_list :product, 5, category: category
      end
      page.evaluate_script('window.location.reload()')
      expect(page).to have_selector('.general-title', count: 12)
      expect(find('.btn-primary', text: I18n.t(:next_page))).to be_present
    end
    scenario 'must present scoups by categories' do
      categories.map(&:name).each do |name|
        expect(first('.filter-link', text: name)).to be_present
      end
    end
  end

  context 'working buttons' do
    scenario 'add product to cart' do
      first('.fa-shopping-cart', visible: :all).trigger('click')
      expect(page).to have_content('Your cart was updated!')
    end
    scenario 'show product' do
      first('.fa-eye', visible: :all).trigger('click')
      expect(page).to have_current_path(/products\/[0-9]+/)
    end
  end
end
