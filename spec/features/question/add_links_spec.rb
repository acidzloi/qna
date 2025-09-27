require 'rails_helper'

feature 'User can add links to question' do
  given(:user) { create(:user) }
  given(:url) { 'https://test.local' }

  scenario 'User adds link when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'Url'
    fill_in 'Url', with: url

    click_on 'Ask'

    expect(page).to have_link 'Url', href: url
  end
end
