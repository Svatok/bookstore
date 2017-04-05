require 'rails_helper'
RSpec.feature 'products/show:' do
  let(:product) { create :full_product }
  let(:order) { create :order }

  before do
    page.set_rack_session(order_id: order.id)
    visit product_path(id: product.id)
  end

  context 'product content' do
    scenario 'must present title' do
      expect(page).to have_content(product.title)
    end
    scenario 'must present short description' do
      expect(page).to have_content(product.description[0..100])
    end
    scenario 'must present authors' do
      product.authors.each do |author|
        expect(page).to have_content(author.first_name + ' ' + author.last_name)
      end
    end
    scenario 'must present price' do
      expect(page).to have_content(product.price_value)
    end
    scenario 'must present other characteristics' do
      expect(page).to have_content(product.property_value('Year of publication'))
      expect(page).to have_content(product.property_value('Materials'))
      expect(page).to have_content(product.dimensions)
    end
    scenario 'add product to cart change total price of order' do
      click_button I18n.t('products.show.add_to_cart')
      expect(page).to have_content('Your cart was updated!')
    end
  end

    context 'reviews content' do

      scenario 'must present count of reviews' do
        expect(page).to have_content(I18n.t('reviews.show_review.reviews') + ' (' + product.reviews.approved.count.to_s + ')')
      end
      scenario 'must present all reviews' do
        reviews_on_page = find('ul.media-list').all('li')
        expect(reviews_on_page.count).to eq(product.reviews.approved.count)
      end
    end

    context 'working form for new review' do
      scenario 'create new review' do
        first('input#rate_value', visible: false).set('5')
        fill_in 'product_review_reviewer_name', with: 'Test User'
        fill_in 'product_review_review_text', with: 'Test Review for Product'
        expect { click_button I18n.t('reviews.form_review.post') }.to change{ product.reviews.count }.by(1)
      end
      scenario 'not valid product rate' do
        first('input#rate_value', visible: false).set('')
        fill_in 'product_review_reviewer_name', with: ''
        fill_in 'product_review_review_text', with: ''
        click_button I18n.t('reviews.form_review.post')
        expect(page).to have_content("Rate can't be blank")
        expect(page).to have_content("Reviewer name can't be blank")
        expect(page).to have_content("Review text can't be blank")
      end
    end
end
