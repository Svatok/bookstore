require 'rails_helper'

RSpec.feature 'Edit user information' do
  let(:user) { create :user_with_addresses }

  before do
    login_as(user, scope: :user)
    visit edit_user_registration_path
  end

  scenario 'redirect to Log In if user is unauthorized' do
    logout(:user)
    visit edit_user_registration_path
    expect(page).to have_current_path('/users/login')
  end

  context 'address information content' do
    scenario 'billing form filled by present billing address' do
      find("button[value='billing']").click
      expect(page).to have_content('Address has been updated.')
    end
    scenario 'shipping form filled by present shipping address' do
      find("button[value='shipping']").click
      expect(page).to have_content('Address has been updated.')
    end
    scenario 'billing form not filled' do
      user.addresses.address_with_type('billing').destroy
      visit edit_user_registration_path
      find("button[value='billing']").click
      expect(page).to have_content("First name can't be blank")
      expect(page).to have_content("Last name can't be blank")
      expect(page).to have_content("Address can't be blank")
      expect(page).to have_content("City can't be blank")
      expect(page).to have_content("Zip can't be blank")
      expect(page).to have_content("Phone can't be blank")
    end
    scenario 'shipping form not filled' do
      user.addresses.address_with_type('shipping').destroy
      visit edit_user_registration_path
      find("button[value='shipping']").click
      expect(page).to have_content("First name can't be blank")
      expect(page).to have_content("Last name can't be blank")
      expect(page).to have_content("Address can't be blank")
      expect(page).to have_content("City can't be blank")
      expect(page).to have_content("Zip can't be blank")
      expect(page).to have_content("Phone can't be blank")
    end
  end
end
