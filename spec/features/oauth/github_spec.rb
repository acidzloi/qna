require 'rails_helper'

feature 'User can sign in with GitHub' do
  describe 'User signs in with GitHub' do
    given!(:user) { create(:user) }

    background { visit new_user_registration_path }

    describe 'login with github account' do
      scenario 'user exist' do
        mock_auth :github, email: user.email
        click_on 'Sign in with GitHub'

        expect(page).to have_content 'Successfully authenticated from Github account.'
      end

      scenario 'user not exist' do
        mock_auth :github, email: 'new_user@test.local'
        click_on 'Sign in with GitHub'
        open_email 'new_user@test.local'
        current_email.click_link 'Confirm my account'

        expect(page).to have_content 'Your email address has been successfully confirmed'

        click_on 'Sign in with GitHub'

        expect(page).to have_content 'Successfully authenticated from Github account.'
      end
    end
  end
end
