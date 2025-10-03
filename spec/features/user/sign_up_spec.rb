require 'rails_helper'

feature 'User can register' do
  given(:user) { create(:user) }

  background { visit new_user_registration_path }

  scenario 'User can register with valid params' do
    fill_in 'Email', with: 'new_user@test.local'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'

    click_button 'Sign up'
    open_email('new_user@test.local')
    current_email.click_link 'Confirm my account'

    expect(page).to have_content 'Your email address has been successfully confirmed.'
    expect(current_path).to eq new_user_session_path
  end

  scenario 'User can not register with invalid params' do
    fill_in 'Email', with: 'user'
    fill_in 'Password', with: ''
    fill_in 'Password confirmation', with: '123'
    click_button 'Sign up'

    expect(page).to have_content "Email is invalid"
    expect(page).to have_content "Password can't be blank"
    expect(page).to have_content "Password confirmation doesn't match"
  end

  scenario 'User can not register with short password' do
    fill_in 'Email', with: 'user@test.loc'
    fill_in 'Password', with: '123'
    fill_in 'Password confirmation', with: '123'
    click_button 'Sign up'

    expect(page).to have_content "Password is too short"
  end

  scenario 'User can not register with existed email' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_button 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end
end
