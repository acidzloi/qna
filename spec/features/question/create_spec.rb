require 'rails_helper'

feature 'User can create question', %q(
  In order to get answer from a comunity
  As an authenticated user
  I'd like to be able to ask the question
) do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question was succesfully created'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a question with attached file' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      attach_file 'files', [ "#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb" ]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'ask a question with badge' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Badge title', with: 'Best answer'
      attach_file 'image', Rails.root.join('public/icon.png').to_s

      click_on 'Ask'

      expect(page).to have_css("img[src*='icon.png']")
    end

    context "multiple sessions", js: true do
      scenario "question appears on another user's page" do
        Capybara.using_session('user') do
          sign_in(user)
          visit questions_path
        end

        Capybara.using_session('guest') do
          visit questions_path
        end

        Capybara.using_session('user') do
          click_on 'Ask question'

          fill_in 'Title', with: 'Test question'
          fill_in 'Body', with: 'text text text'
          click_on 'Ask'

          expect(page).to have_content 'Your question was succesfully created'
          expect(page).to have_content 'Test question'
          expect(page).to have_content 'text text text'
        end

        Capybara.using_session('guest') do
          expect(page).to have_content 'Test question'
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
