require 'rails_helper'

RSpec.feature 'Log in user' do

  before do
    create :user, email: 'test@test.com', password: 'TestPassword2017', confirmed_at: Date.today
    visit '/users/login'
  end

  scenario 'Log In title' do
    expect(page).to have_content(I18n.t('devise.sessions.new.log_in'))
  end

  scenario 'success login' do
    fill_in 'user_email', with: 'test@test.com'
    fill_in 'user_password', with: 'TestPassword2017'
    click_button I18n.t('devise.sessions.new.log_in')
    expect(page).to have_content('Signed in successfully.')
  end

  scenario 'Log in form not filled' do
    click_button I18n.t('devise.sessions.new.log_in')
    expect(page).to have_content('Invalid Email or password.')
  end

end
