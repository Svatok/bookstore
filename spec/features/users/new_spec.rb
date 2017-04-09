require 'rails_helper'

RSpec.feature 'Sign up new user' do

  before { visit '/users/sign_up' }

    scenario 'Sign UP title' do
      expect(page).to have_content(I18n.t('devise.registrations.new.sign_up'))
    end

    context 'success registration' do
      before do
        clear_emails
        fill_in 'user_email', with: 'test@test.com'
        fill_in 'user_password', with: 'TestPassword2017'
        fill_in 'user_password_confirmation', with: 'TestPassword2017'
        click_button I18n.t('devise.registrations.new.sign_up')
        @user = User.find_by(email: 'test@test.com')
      end
      scenario 'message' do
        expect(page).to have_content('A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.')
      end
      scenario 'letter' do
        open_email(@user.email)
        expect(current_email).to have_content 'Confirm my account'
      end
    end

    scenario 'Sign UP form not filled' do
      click_button I18n.t('devise.registrations.new.sign_up')
      expect(page).to have_content("Email can't be blank")
      expect(page).to have_content("Password can't be blank")
    end

end
