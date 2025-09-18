require 'rails_helper'

feature 'User can create answer', %q(
  As an authenticated user
  being on the question page
  I'd like to create the answer to the question
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'create answer' do
      fill_in 'Body', with: 'first answer'
      click_on 'Answer'

      expect(page).to have_content 'Answer successfully created.'
      expect(page).to have_content 'first answer'
    end

    scenario 'create answer with errors', js: true do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to create a answer' do
    visit question_path(question)
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Authenticated user creates answer with errors', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Answer'

    expect(page).to have_content "Body can't be blank"
  end
end
