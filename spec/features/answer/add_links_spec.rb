require 'rails_helper'

feature 'User can add links to answer' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:url) { 'https://test.local' }

  scenario 'User adds link to answer', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Body', with: 'My answer'

    fill_in 'Link name', with: 'Url'
    fill_in 'Url', with: url

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'Url', href: url
    end
  end
end
